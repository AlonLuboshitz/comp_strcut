/*Alon Luboshitz 312115090*/
#include "cache.h"
#include <stdlib.h>
#include <stdio.h>
cache_t initialize_cache(uchar s, uchar t, uchar b, uchar E) {
    cache_t cache;
    cache.s = s;
    cache.t = t;
    cache.b = b;
    cache.E = E;
    cache.m = s + t + b;
    cache.cache = malloc(2<<(s-1));
    for (int i = 0; i < (2<<(s-1)); i++) {
        cache.cache[i] = init_lines(E, b);
    }
    return cache;
}
cache_line_t* init_lines(uchar E,uchar b){
    cache_line_t* lines = malloc(E * sizeof(cache_line_t));
    int block_size = 2<<(b-1);
    for (int i = 0; i < E; i++) {
        lines[i].valid = 0;
        lines[i].frequency = 0;
        lines[i].tag = 0;
        lines[i].block = malloc(block_size * sizeof(uchar));
    }
    return lines;
}
// Extract the first n bits from int off
unsigned int* extract_bits(long int off, unsigned int n){
    // Create char array with n bits to store the result
    
    unsigned int* arr = malloc(n * sizeof(unsigned int));
    for (int i = 0; off != 0 || i < n; i++) {
        arr[i] = off % 2;
        off /= 2;
    }
    
    return arr;
    
    
}
void print_address(unsigned int* arr, unsigned int n){
    for (; n != 0 ; n--) {
        printf("%d", arr[n-1]);
    }
    printf("\n");
}
uchar read_byte(cache_t cache, uchar* start, long int off){
    // Turn addres to bits
    unsigned int* address_bit  = extract_bits(off,cache.m);
    // Extract the tag bits first t bits
    long int tag = 0;
    int S = 0;
    int b_off_set = 0;
    extract_tag_set_block(cache, address_bit, &S, &b_off_set, &tag);
    cache_line_t* lines = cache.cache[S];
    uchar* block = start + (off-b_off_set);
    insert_line(lines, tag, cache.E, block);
    
    free(address_bit);

}
/* write through and write no allocate.
if no line in cache update striaght foward the ram */

void write_byte(cache_t cache, uchar* start, long int off, uchar new) {
    unsigned int* address_bit  = extract_bits(off,cache.m);
    long int tag = 0;
    int S = 0;
    int b_off_set = 0;
    extract_tag_set_block(cache, address_bit, &S, &b_off_set, &tag);
    cache_line_t* lines = cache.cache[S];
    // update the line in the cache
    uchar* block = start + (off-b_off_set);
    update_line(lines, tag, cache.E, b_off_set, new, block);
    // update the value in the RAM
    
    *(block) = new;
    
    free(address_bit);

}
void update_line(cache_line_t* line, long int tag, uchar E,int off_set, uchar new, uchar* block){
    int line_index = if_line_exsits(line, tag, E);  
    if (line_index != -1) {
        
        line[line_index].block[off_set] = new;
    }
    else {
        line_index = find_empty_or_min_line(line, E);
        line[line_index].tag = tag;
        line[line_index].valid = 1;
        line[line_index].frequency = 1;
        line[line_index].block = block;
        line[line_index].block[off_set] = new;

    }
}
//Function returns the line index if the line exists, else returns -1
int if_line_exsits(cache_line_t* line, long int tag, uchar E){
    for (int i = 0; i < E; i++) {
        if (line[i].tag == tag && line[i].valid == 1) {
            line[i].frequency++;
            return i;
        }
    }
    return -1;
}

// Function returns the index of the empty line or the line with the minimum frequency
int find_empty_or_min_line(cache_line_t* line, uchar E){
    int min = 2;
    int min_index = 0;
    for (int i = 0; i < E; i++) {
        if (line[i].valid == 0) {
            return i;
        }
        if (line[i].frequency < min) {
            min = line[i].frequency;
            min_index = i;
        }
    }
    return min_index;
}
/* Insert line to cache:
if line exists update freq
if not find empty spot or minimum freq and insert the line*/
void insert_line(cache_line_t* line, long int tag, uchar E,uchar* block) {
    if (if_line_exsits(line, tag, E) != -1) {
        return;
    }
    else {
        int index = find_empty_or_min_line(line, E);
        line[index].tag = tag;
        line[index].valid = 1;
        line[index].frequency = 1;
        line[index].block = block;

    }

}
// run over m bits of address and extract the corresponding bits for each value
void extract_tag_set_block(cache_t cache, unsigned int* address,int* S, int* b_off_set, long int* Tag){
    *b_off_set = 0;
    *Tag = 0;
    *S = 0;
    int i = 0;
    for (int b = 0; b < cache.b; b++) {
            int temp = address[i];
            temp <<= b;
            (*b_off_set) += temp;
            i++;
    }
    for (int s = 0; s < cache.s; s++) {
            int temp = address[i];
            temp <<= s;
            *S += temp;
            i++;
    }
    for(int t = 0; t < cache.t; t++){
            int temp = address[i];
            temp <<= t;
            *Tag += temp;
            i++;    
    }
    
}
void free_cache_lines(cache_t cache){
    for (int i = 0; i < (2<<(cache.s-1)); i++) {
        free(cache.cache[i]);
    }
    free(cache.cache);

}
void print_cache(cache_t cache) {
 int S = 1 << cache.s;
 int B = 1 << cache.b;

 for (int i = 0; i < S; i++) {
printf("Set %d\n", i);
 for (int j = 0; j < cache.E; j++) {
     printf("%1d %d 0x%0*lx ", cache.cache[i][j].valid,
 cache.cache[i][j].frequency, cache.t, cache.cache[i][j].tag);
 for (int k = 0; k < B; k++) {
 printf("%02x ", cache.cache[i][j].block[k]);
}
 puts("");
 }
 }
  }
