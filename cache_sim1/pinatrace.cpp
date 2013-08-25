/*BEGIN_LEGAL 
Intel Open Source License 

Copyright (c) 2002-2013 Intel Corporation. All rights reserved.
 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.  Redistributions
in binary form must reproduce the above copyright notice, this list of
conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.  Neither the name of
the Intel Corporation nor the names of its contributors may be used to
endorse or promote products derived from this software without
specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE INTEL OR
ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
END_LEGAL */
/*
 *  This file contains an ISA-portable PIN tool for tracing memory accesses.
 */

#include <stdio.h>
#include "pin.H"
#include <vector>
#include <iostream>
#include <stdio.h>
#include <vector>
#include <math.h>

using namespace std;

#define LRU_BITS 6;

enum cache_event {hit,miss};
enum cache_op {read_ops,write_ops};
enum Replacement_Policy { LRU };

struct cache_entry {

    vector<char> data;  
    int tag;
    int LRU;
    bool dirty;
    bool valid;
};

//implementing the logger class

class logger {

public: 
    vector<cache_event> event_log;// says if hit/miss
    vector<int> eve_level; // says where it occured
    vector<int> event_cost; //cost of an event
    vector<cache_op> cac_op; // what operation - read/write
    int cache_levels; // specify the levels of cache

//default constructor

    logger(vector<int> costs,int levels) {
        event_cost = costs;
        cache_levels = levels;
    }
    
    void set_params(vector<int> costs,int levels) {

        event_cost = costs;
        cache_levels = levels;
    }

// the event handler

    void log_event(cache_event c_eve,cache_op c_op,int c_level) {

        this->eve_level.push_back(c_level); //pushing the cache where the event occured
        this->cac_op.push_back(c_op); // what cache operation
        this->event_log.push_back(c_eve); // hit/miss
    }

    //print function
    void print_event(FILE* fp) {
	// analytics here this is variable to situation
	int c_event_log[] = {0,0,0,0};

	int i = 0;
	for(i = 0;i < (int)this->event_log.size();i++){
	    if((this->event_log[i] == hit)&&(this->eve_level[i] == 1)){
		c_event_log[0]++;
	    }
	    else if((this->event_log[i] == miss)&&(this->eve_level[i] == 1)){
		c_event_log[1]++;
	    }
	    else if((this->event_log[i] == hit)&&(this->eve_level[i] == 2)){
		c_event_log[2]++;
	    }
	    else if((this->event_log[i] == miss)&&(this->eve_level[i] == 2)){
		c_event_log[3]++;
	    }
	}
	
	fprintf(fp,"L1 hits: %d \n",c_event_log[0]);
	fprintf(fp,"L1 miss: %d \n",c_event_log[1]);
	fprintf(fp,"L2 hits: %d \n",c_event_log[2]);
	fprintf(fp,"L2 miss: %d \n",c_event_log[3]);

	fprintf(fp,"L1 miss ratio: %d \n",(100*(c_event_log[1]))/(c_event_log[0]+c_event_log[1]));
	fprintf(fp,"L2 miss ratio: %d \n",(100*(c_event_log[3]))/(c_event_log[2]+c_event_log[3]));
    }
};


// implementing main memory
class main_memory {

public:  
    // this is the implementation for the main memory
    int size; // the memory size
    int bus_size; // the amount of bits that can be written
    int parallel_read; // the number of parallel reads
    int parallel_writes; // the number of paralle writes
    int parallel_ops; // the parallen ops
    int address_size; // the address width
    int level_value;
    logger* log_elem;

    main_memory(int size,int bus_size,int address_size,int level_val) {

        this->size = size;
        this->bus_size = size;
        this->address_size = address_size;
        this->parallel_ops = bus_size/address_size;
        this->level_value = level_val;
    }

    void read_c_(int address,int data) {
        //implement read here
        log_elem->log_event(hit,read_ops,level_value);
    }

    void write_c_(int address,int data) {
        // implement a write here
        //must call an observer class here
        log_elem->log_event(hit,write_ops,level_value);
    }
    
};

// processor
class processor {

public:  
    // this is the processor class…
    void read_c_(){
	//issue the address here
    }
    
    void write_c_(){
	//issue the address here
    }
};

class cache {

public:  
    int id;
    int size;
    int block_size;
    int associativity;    
    int num_blocks;
    int tag_size;
    int idx_size;
    int off_size;    
    int address_size;    
    bool read_flag;    
    Replacement_Policy rp;
    vector<vector<cache_entry> > entries;    
    bool hasLevel;
    cache* nextLevel;
    main_memory* topLevel;
    logger* log_elem;

    cache(int address_size,int id, int size, int block_size, int associativity, Replacement_Policy rp) {

	this->address_size = address_size;      
        this->id = id;
        this->size = size;
        this->block_size = block_size;
        this->associativity = associativity;
        this->rp = rp;	
	this->num_blocks = size/(block_size*associativity);

	this->off_size = round(log2(block_size));
	this->idx_size = round(log2(num_blocks));
	this->tag_size = round(log2(address_size)) - off_size - idx_size;
	
	this->read_flag = true;
	
	//initiallizing the cache with empty blocks!
	cache_entry def_block;
	def_block.valid = false;
	def_block.tag = 0;
	def_block.LRU = 0;
	def_block.dirty = false;
	
	vector<cache_entry> cache_row(associativity,def_block);
	int i;
	for(i = 0;i < num_blocks;i++){
	    entries.push_back(cache_row);
	}
	
    }

//Functions

    bool exists(int address) {

        int idx;
	bool got_tag = false;
	
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
	for(idx = 0;idx < associativity;idx++){
	    
	    if(entries[add_idx][idx].valid){
		if(entries[add_idx][idx].tag == add_tag){
		    got_tag = true;
		}
	    }
	}
	
	return got_tag;
    }

// Tries to read
    int get_tag(int address){
	return (address >> (idx_size + off_size));
    }
    
    int get_index(int address){
	return ((address >> (off_size)) & ( (2 << (idx_size+1) ) -1) );
    }
    
    int get_offset(int address){
	return (address & ( (2 << (off_size+1)) -1) );
    }


    bool read_c_(int address) {      
        if(exists(address) && has_valid_data(address)) {
            log_elem->log_event(hit, read_ops, this->id);
	    replacement_update(address);
            return true;
        } else {
            log_elem->log_event(miss, read_ops, this->id);
            return false;
        }
    }

// Tries to write
    bool has_valid_data(int address){
	int idx;
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
	for(idx = 0;idx < associativity;idx++){
	    
	    if(entries[add_idx][idx].tag == add_tag){
		if(entries[add_idx][idx].valid){
		    return true;
		}
		else{
		    return false;
		}
	    }
	}
	
	return false;
    }

    bool write_c_(int address) {
        if(exists(address)) {
            log_elem->log_event(hit, write_ops, this->id);
	    replacement_update(address);
            setDirtyBit(address,true);
            return true;
        } else {
            log_elem->log_event(miss, write_ops, this->id);
	     //kick out a block and put new one
	    
	    read_flag = false;
	    cache_entry new_wr_blk = return_block_read(address);
	    read_flag = true;
	    put_block(address,new_wr_blk);
	    
            return false;
        }

    }

    void setValidBit(int address,bool val) {
	
	int idx;
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
	for(idx = 0;idx < associativity;idx++){
	    if(entries[add_idx][idx].tag == add_tag){
		entries[add_idx][idx].valid = val;
	    }
	}
    }

    void setDirtyBit(int address,bool val) {
	
	int idx;
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
	for(idx = 0;idx < associativity;idx++){
	    
	    if(entries[add_idx][idx].valid){
		if(entries[add_idx][idx].tag == add_tag){
		    entries[add_idx][idx].dirty = val;
		}
	    }
	}
    }
    
    void replacement_update(int address){
	int idx;
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
	for(idx = 0;idx < associativity;idx++){
	    
	    if(entries[add_idx][idx].valid){
		if(entries[add_idx][idx].tag != add_tag){
		    entries[add_idx][idx].LRU++;
		    entries[add_idx][idx].LRU %= 2<<LRU_BITS;
		}
	    }
	}
    }
    
    cache_entry return_block_read(int address){
      
	bool read_miss = true;
      
	if(read_flag){
	    if(read_c_(address)){
		read_miss = false;
		return get_block(address);
	    }
	}
	
	if(read_miss){
	    //ask higher
	    if(hasLevel){
		cache_entry tmpBlk =  nextLevel->return_block_read(address);
		tmpBlk.tag = get_tag(address);
		put_block(address,tmpBlk);
		return tmpBlk;
	    }
	    else{
	      
		//taking from main memory
		topLevel->read_c_(address,0);
		
		cache_entry newBlock;
		newBlock.dirty = false;
		newBlock.valid = true;
		newBlock.LRU = 0;
		newBlock.tag = get_tag(address);
		
		put_block(address,newBlock);
		
		return newBlock;
	    }
	}
	else{
	    cache_entry dummy_var;
	    dummy_var.dirty = false;
	    dummy_var.valid = true;
	    dummy_var.LRU = 0;
	    dummy_var.tag = 0;
	    return dummy_var;
	}
    }
    
    cache_entry get_block(int address){
	
	int idx;
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
	for(idx = 0;idx < associativity;idx++){
	    
	    if(entries[add_idx][idx].valid){
		if(entries[add_idx][idx].tag == add_tag){
		    return entries[add_idx][idx];
		}
	    }
	}
	
	//dummy piece
	cache_entry dummy_var;
	dummy_var.dirty = false;
	dummy_var.valid = true;
	dummy_var.LRU = 0;
	dummy_var.tag = 0;
	return dummy_var;
    }
    
    void put_block(int address,cache_entry new_blk){
	
	int add_idx = get_index(address);

	new_blk.dirty = true;
	
	//bring replacement policy here..!!
	int idx = 0;
	int min_idx = idx;
	int min_val = entries[add_idx][idx].LRU;
	for(idx = 1;idx < associativity;idx++){
	    if(min_val < entries[add_idx][idx].LRU){
		min_idx = idx;
		min_val = entries[add_idx][idx].LRU;
	    }
	}
	
	entries[add_idx][min_idx].dirty = true;
	
	//replace..
	if(entries[add_idx][min_idx].dirty){
	    if(hasLevel){
		nextLevel->put_block(address,entries[add_idx][min_idx]);
	    }
	    else{
		topLevel->write_c_(address,0);
	    }
	}
	
	entries[add_idx][min_idx].valid = false;
	
	entries[add_idx][min_idx] = new_blk;
    }

};

FILE * trace;

vector<cache*> main_cache;
main_memory* ram_mem;
logger* cap_eve_log;

void read_build_cache(FILE* ip_data){
    
    //TODO: all this from file pointer
    vector<int> costs;
    costs.push_back(4);
    costs.push_back(16);
    costs.push_back(16);
    costs.push_back(200);
    
    cap_eve_log = new logger(costs,3);
    
    main_cache.push_back(new cache(32,0,32*1024,32,4,LRU));
    main_cache.push_back(new cache(32,1,64*1024,32,8,LRU));
    
    ram_mem = new main_memory(0,0,0,0);
    ram_mem->level_value = 2;
    ram_mem->log_elem = cap_eve_log;
    
    main_cache[0]->nextLevel = main_cache[1];
    main_cache[0]->hasLevel = true;
    main_cache[0]->log_elem = cap_eve_log;
    
    main_cache[1]->topLevel = ram_mem;
    main_cache[1]->hasLevel = false;
    main_cache[1]->log_elem = cap_eve_log;
}


// Print a memory read record
VOID RecordMemRead(VOID * ip, VOID * addr)
{
    fprintf(trace,"%p: R %p\n", ip, addr);
    
    cache_entry tmp_bk;
    tmp_bk = main_cache[0]->return_block_read((int)ip);
    tmp_bk = main_cache[0]->return_block_read((int)addr);
}

// Print a memory write record
VOID RecordMemWrite(VOID * ip, VOID * addr)
{
    fprintf(trace,"%p: W %p\n", ip, addr);
    
    main_cache[0]->write_c_((int)ip);
    main_cache[0]->write_c_((int)addr);
}

// Is called for every instruction and instruments reads and writes
VOID Instruction(INS ins, VOID *v)
{
    // Instruments memory accesses using a predicated call, i.e.
    // the instrumentation is called iff the instruction will actually be executed.
    //
    // On the IA-32 and Intel(R) 64 architectures conditional moves and REP 
    // prefixed instructions appear as predicated instructions in Pin.
    UINT32 memOperands = INS_MemoryOperandCount(ins);

    // Iterate over each memory operand of the instruction.
    for (UINT32 memOp = 0; memOp < memOperands; memOp++)
    {
        if (INS_MemoryOperandIsRead(ins, memOp))
        {
            INS_InsertPredicatedCall(
                ins, IPOINT_BEFORE, (AFUNPTR)RecordMemRead,
                IARG_INST_PTR,
                IARG_MEMORYOP_EA, memOp,
                IARG_END);
        }
        // Note that in some architectures a single memory operand can be 
        // both read and written (for instance incl (%eax) on IA-32)
        // In that case we instrument it once for read and once for write.
        if (INS_MemoryOperandIsWritten(ins, memOp))
        {
            INS_InsertPredicatedCall(
                ins, IPOINT_BEFORE, (AFUNPTR)RecordMemWrite,
                IARG_INST_PTR,
                IARG_MEMORYOP_EA, memOp,
                IARG_END);
        }
    }
}

VOID Fini(INT32 code, VOID *v)
{
    fprintf(trace, "#eof\n");
    fclose(trace);
}

/* ===================================================================== */
/* Print Help Message                                                    */
/* ===================================================================== */
   
INT32 Usage()
{
    PIN_ERROR( "This Pintool prints a trace of memory addresses\n" 
              + KNOB_BASE::StringKnobSummary() + "\n");
    return -1;
}

/* ===================================================================== */
/* Main                                                                  */
/* ===================================================================== */

int main(int argc, char *argv[])
{
    //assuming this is the input file
    FILE* cachce_set_param = fopen("cache_data.in","r");
    
    read_build_cache(cachce_set_param);
  
    if (PIN_Init(argc, argv)) return Usage();

    trace = fopen("pinatrace.out", "w");

    INS_AddInstrumentFunction(Instruction, 0);
    PIN_AddFiniFunction(Fini, 0);

    // Never returns
    PIN_StartProgram();
    
    return 0;
}
