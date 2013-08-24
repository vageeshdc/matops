/*
1. Main memory

2. Cache

3. Processor

4. Tracing class
*/

//enum for the cache event
#include <iostream>
#include <stdio.h>
#include <vector>
#include <math.h>

using namespace std;

#define LRU_BITS 6;

enum cache_event {hit,miss};

enum cache_op {read,write};

enum Replacement_Policy { LRU };

struct cache_entry {

    vector<uchar> data;
  
    int tag;

    int LRU;

    bool dirty;

    bool valid;
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
    
    bool read_flag = true;
    
    Replacement_Policy rp;

    vector<vector<cache_entry>> entries;
    
    bool hasLevel = false;
    cache* nextLevel;
    main_memory* topLevel;

    cache(int address_size,int id, int size, int block_size, int associativity, Replacement_Policy rp) {

	this.address_size = address_size;
      
        this.id = id;

        this.size = size;

        this.block_size = block_size;

        this.associativity = associativity;

        this.rp = rp;
	
	this.num_blocks = size/(block_size*associativity);

	this.off_size = round(log2(block_size));
	this.idx_size = round(log2(num_blocks));
	this.tag_size = round(log2(address_size)) - off_size - idx_size;
	
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
	return ((address >> (off_size)) & ( (pow(2,idx_size+1)) -1) );
    }
    
    int get_offset(int address){
	return (address & ( (pow(2,off_size+1)) -1) );
    }


    bool read(int address) {
      
        if(this.exists(address)) {

            logger::log_event(cache_event::hit, cache_op::read, this.id);
	    replacement_update(address);
            return true;

        } else {

            logger::log_event(cache_event::miss, cache_op::read, this.id);

            return false;

        }

    }

// Tries to write

    bool write(int address) {

        if(this.exists(address)) {

            logger::log_event(cache_event::hit, cache_op::write, this.id);
	    replacement_update(address);
            setDirtyBit(address,true);

            return true;

        } else {

            logger::log_event(cache_event::miss, cache_op::write, this.id);
	    
	    //kick out a block and put new one
	    
	    read_flag = false;
	    cache_entry new_wr_blk = return_block_read(address);
	    read_flag = true;
	    put_block(new_wr_blk);
	    
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
	    if(read(address)){
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
		topLevel->read(address,0);
		
		cache_entry newBlock;
		newBlock.dirty = false;
		newBlock.valid = true;
		newBlock.LRU = 0;
		newBlock.tag = get_tag(address);
		
		put_block(address,newBlock);
		
		return newBlock;
	    }
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
    }
    
    void put_block(int address,cache_entry new_blk){
	int idx;
	int add_idx = get_index(address);
	int add_tag = get_tag(address);
	
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
		topLevel->write(address,0);
	    }
	}
	
	entries[add_idx][min_idx].valid = false;
	
	entries[add_idx][min_idx] = new_blk;
    }

};

//========================================

//implementing the logger class

class logger {

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
    
    static set_params(vector<int> costs,int levels) {

        event_cost = costs;

        cache_levels = levels;

    }

// the event handler

    static void log_event(cache_event c_eve,cache_op c_op,int c_level) {

        eve_level.push_back(c_level); //pushing the cache where the event occured

        cac_op.push_back(c_op); // what cache operation

        event_log.push_back(c_eve); // hit/miss

    }

    //print function

    static void print_event(FILE* fp) {

	// analytics here this is variable to situation
	int c_event_log[] = {0,0,0,0};
	
	int i = 0;
	for(i = 0;i < event_log.size();i++){
	    if((event_log[i] == cache_event::hit)&&(eve_level[i] == 1)){
		c_event_log[0]++;
	    }
	    else if((event_log[i] == cache_event::miss)&&(eve_level[i] == 1)){
		c_event_log[1]++;
	    }
	    else if((event_log[i] == cache_event::hit)&&(eve_level[i] == 2)){
		c_event_log[2]++;
	    }
	    else if((event_log[i] == cache_event::miss)&&(eve_level[i] == 2)){
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



    // this is the implementation for the main memory

    int size; // the memory size

    int bus_size; // the amount of bits that can be written

    int parallel_read; // the number of parallel reads

    int parallel_writes; // the number of paralle writes

    int parallel_ops; // the parallen ops

    int address_size; // the address width

    int level_value;

    main_memory(int size,int bus_size,int address_size,int level_val) {

        this.size = size;

        this.bus_size = size;

        this.address_size = address_size;

        parallel_ops = bus_size/address_size;

        this.level_value = level_val;

    }

    void read(uint address,uint data) {

        //implement read here

        logger:: log_event(cache_event::hit,cache_op::read,level_value);

    }

    void write(uint address,uint data) {

        // implement a write here

        //must call an observer class here

        logger:: log_event(cache_event::hit,cache_op::write,level_value);

    }
    
};

// processor

class processor {

    // this is the processor class…
    void read(){
	//issue the address here
    }
    
    void write(){
	//issue the address here
    }
};



