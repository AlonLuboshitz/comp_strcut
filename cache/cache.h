/*Alon Luboshitz 312115090*/
#ifndef CACHE_H
#define CACHE_H

typedef unsigned char uchar;

 typedef struct cache_line_s {
 uchar valid;
 uchar frequency;
 long int tag;
 uchar* block;
 } cache_line_t;

typedef struct cache_s {
uchar s;
uchar t;
uchar b;
uchar E;
cache_line_t** cache;
unsigned int m;
} cache_t;
void insert_line(cache_line_t* line, long int tag, uchar E,uchar* block) ;
void print_cache(cache_t cache);
void free_cache_lines(cache_t cache);
cache_t initialize_cache(uchar s, uchar t, uchar b, uchar E);
int init_sets(cache_line_t** Sets, int S, uchar E, uchar b);
int init_one_line(cache_line_t* line, uchar b);
int if_line_exsits(cache_line_t* line, long int tag, uchar E);
int find_empty_or_min_line(cache_line_t* line, uchar E);
uchar read_byte(cache_t cache, uchar* start, long int off);
void print_address(unsigned int* arr, unsigned int n);
void extract_tag_set_block(cache_t cache, unsigned int* address,int* S, int* b_off_set, long int* Tag);
void write_byte(cache_t cache, uchar* start, long int off, uchar new);
void update_line(cache_line_t* line, long int tag, uchar E,int off_set, uchar new, uchar* block);
#endif