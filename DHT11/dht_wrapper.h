#ifndef dht_wrapper_h
#define dht_wrapper_h

#if defined __cplusplus

extern "C" {

typedef void * dhttype; 
dhttype dht11_constructor( void );
int read_wrapper( dhttype  a_dhttype,  int pin );
const int getTemperature_wrapper(dhttype a_dhttype);
const int getHumidity_wrapper(dhttype a_dhttype);
dhttype dht11_destructor( dhttype a_dhttype);
	
#if defined __cplusplus
}
#endif

#endif
