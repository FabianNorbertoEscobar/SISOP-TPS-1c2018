#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include <string.h>


int main( int argc , char *argv[] )
{ 

  int fd=0;
  fd=open("./nuevo/fifo", O_WRONLY );
  char mensaje[] = "ventasesta es una linea larga de texto";
  write(fd, mensaje, strlen(mensaje) + 1 );
  
  close(fd);
  
  return 0;
}
