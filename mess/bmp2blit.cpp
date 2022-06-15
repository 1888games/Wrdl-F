#include<iostream>
#include <fstream>    
#include <stdio.h>
#include <stdlib.h>

/*

   Converter that converts 1 bit color bitmap into VES BlitGraphic-data
   or 4 bit color bitmap into VES MultiBlitGraphics.
   
   BlitGraphic and MultiBlitGraphic as described at http://veswiki.com

   The parameter -i after the filename inverts the output of the 1-bit bmp.
   
   The color table of the 4 bit color bitmap is interpreted this way, first
   recommended color in color table and then the interpretation 
   (if they're not the same):
       
   Color 0: black - *background
         1: *blue
         2: *green
         3: *red
         4: lt green - *background
         5: lt blue  - *background
         6: lt grey  - *background
         7: white - *blue (looks white in b&w mode)
         8-15: Treated as background
    
    The reason for choosing this particular color table is because that's the
    result when converting a Channel F emulation screen snapshot in MESS from 
    a 24 bit color png into a 16 color version...
    
    Picture is centered on screen if it's smaller than the visible screen area.

*/

using namespace std;


int main (int argc, char* argv[])   // argc: number of arguments including itself, to allow drop of file
{
    
  char  tmpch, *inputfilename="bitmap.bmp", *filefolder, *shortname="bitmap.bmp", *invert_arg;
  char  buffer[164000], buffer2[41000], buffer3[164000];
  int   readbytes=0, filenamesize=0;
  int   bitcounter=0, bytecounter=0, picWidth=0, picHeight=0, heightTmp=0, widthTmp=0, tmp=1, bintmp=0, bintmp2=0;

  if (argc>1) 
  {
     inputfilename=argv[1]; 

     filefolder = argv[0];
  
     while (filefolder[tmp-1])
     {
        if (filefolder[tmp-1]=='\\') readbytes=tmp-1;
        tmp++;
     }
     filefolder[readbytes+1]='\0';
     
//     cout << "\n\n" << filefolder << "***\n\n";
//     cout << inputfilename << "\n\n";     
     
     tmp = 1;    
     
     filenamesize=0;
     
     while(inputfilename[readbytes+tmp]) 
     {
        filenamesize++;
        tmp++;
     }
     
     shortname = (char*) malloc (filenamesize+1);
     
     // cout << "\n\n" << filenamesize << "\n\n";
     
     shortname[filenamesize] = '\0';
     
     tmp = 0;
     while(inputfilename[readbytes+tmp+1]) 
     {
        shortname[tmp]=inputfilename[readbytes+tmp+1];
        if ( shortname[tmp]==' ') shortname[tmp]='_';
        tmp++;
     }     
  
  }


  cout << "\n1 or 4 bit BMP to Channel F graphic converter by Fredric Blaoholtz 2008\n\n";
  cout << "Drop a file on the icon or rename file to bitmap.bmp and double-click\n\n";
  cout << "Output is called ves_graphic.data.txt\n";
  cout << "\n\nName of file  : " << shortname;
 
  ifstream filin(inputfilename, ios::binary);                    // Open input file
         if (!filin){                               // Errorcheck exit with 1 
          cout << "\a\n Input file error: " << inputfilename << "\n Program will exit\n\n";
          cin >> ws;
          exit(1);
       }  


   ofstream filout(strcat (filefolder, "ves_graphic.data.txt"), ios::binary | ios_base::app);    // Output file
       if (!filout){                                   // Errorcheck exit with 2 
          cout << "\a\n Output file error: ves_graphic.data.txt\n Program will exit.\n\n";
          filin.close();
          cin >> ws;
          exit(2);
       }  

  // Check if it's a BMP file
  
  filin.get(tmpch);
  if (tmpch!='B'){
     cout << "\a\nIndata is not bmp-file, program exits.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(3);
  }
  filin.get(tmpch);
  if (tmpch!='M'){
     cout << "\a\nIndata is not bmp-file, program exits.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(3);
  }
  
  // Skip forward in file header to width

  filin.get(tmpch);  // Byte 3
  filin.get(tmpch);  // Byte 4
  filin.get(tmpch);  // Byte 5
  filin.get(tmpch);  // Byte 6
  filin.get(tmpch);  // Byte 7
  filin.get(tmpch);  // Byte 8
  filin.get(tmpch);  // Byte 9
  filin.get(tmpch);  // Byte 10
  filin.get(tmpch);  // Byte 11
  filin.get(tmpch);  // Byte 12
  filin.get(tmpch);  // Byte 13
  filin.get(tmpch);  // Byte 14
  filin.get(tmpch);  // Byte 15
  filin.get(tmpch);  // Byte 16
  filin.get(tmpch);  // Byte 17
  filin.get(tmpch);  // Byte 18
 
  filin.get(tmpch);  // Byte 19
  // cout << " " << int(tmpch) << " ";

  // save width
  picWidth=0xFF & int(tmpch);
  widthTmp=picWidth;

  bintmp = 0;
  
  filin.get(tmpch);                       // Byte 20
  //   cout << " " << int(tmpch) << " ";
  bintmp=bintmp+(0xff & int(tmpch));
  filin.get(tmpch);                       // Byte 21
  //   cout << " " << int(tmpch) << " ";
  bintmp=bintmp+(0xff & int(tmpch));
  filin.get(tmpch);                       // Byte 22
  //   cout << " " << int(tmpch) << " ";
  bintmp=bintmp+(0xff & int(tmpch));

  if (bintmp!=0){
     cout << "\a\nPicture is too large, program exits.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(6);
  }

  bintmp = 0;


  if (picWidth>128 || picWidth < 0){
     cout << "\a\nPicture is wider than 128 pixels, program exits.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(4);
  }
  
  cout << "\nPicture width : " << picWidth;

  filin.get(tmpch);                       // Byte 23
  //   cout << " " << int(tmpch) << " ";

  // save height
  picHeight=0xFF & int(tmpch);
  heightTmp=picHeight;


  bintmp = 0;
  
  filin.get(tmpch);                       // Byte 24
  //   cout << " " << int(tmpch) << " ";
  bintmp=bintmp+(0xff & int(tmpch));
  filin.get(tmpch);                       // Byte 25
  //   cout << " " << int(tmpch) << " ";
  bintmp=bintmp+(0xff & int(tmpch));
  filin.get(tmpch);                       // Byte 26
  //   cout << " " << int(tmpch) << " ";
  bintmp=bintmp+(0xff & int(tmpch));

  if (bintmp!=0){
     cout << "\a\nPicture is too large, program exits.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(6);
  }

  bintmp = 0;


  if (picHeight>64){
     cout << "\a\nPicture is higher than 64 pixels, program exits.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(5);
  }
  
  cout << "\nPicture height: " << picHeight;
   

// Check number of bits per pixel is 4 or 1

  filin.get(tmpch);                       // Byte 27
  // cout << " " << int(tmpch) << " ";
  filin.get(tmpch);                       // Byte 28
  //  cout << " " << int(tmpch) << " ";
  filin.get(tmpch);                       // Byte 29
  //  cout << " " << int(tmpch) << " ";
  
  tmp=(int(tmpch) & 0xFF);
  
  filin.get(tmpch);                       // Byte 30
  //  cout << " " << int(tmpch) << " ";
  if (((int(tmpch)) & 0xFF) !=0) {
     cout << "\a\nPicture is not a 2 or 16-color picture.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(5);          
  }
  
  cout << "\nBits per pixel: " << tmp;
  if (tmp!=4 && tmp != 1 ){
     cout << "\a\nPicture is not a 2 or 16-color picture.";
     filin.close();
     filout.close();
     cin >> ws;
     exit(5);
  }

  cout << "\n";

  bintmp=51-(picWidth/2);
  if (bintmp < 0) bintmp=0;
  bintmp2=27-(picHeight/2);
  if (bintmp2 < 0) bintmp2=0;

  filout << "\n\n;---------------------------------------------------------------------------\n";
  filout << ";   " << shortname << "\n";
  filout << ";---------------------------------------------------------------------------\n\n";
  filout << "gfx." << shortname << ".parameters:\n";
  
  if (tmp==1){
  
    filout << "\t\t.byte\tbkg\t\t\t; color 1 (clear/bkg/blue/red/green)\n";
    filout << "\t\t.byte\tblue\t\t\t; color 2 (clear/bkg/blue/red/green)\n";  
  
  }
  filout << "\t\t.byte\t" << bintmp  << "\t\t\t; x position\n";
  filout << "\t\t.byte\t" << bintmp2 << "\t\t\t; y position\n";
  filout << "\t\t.byte\t";
  filout << picWidth;
  filout << "\t\t\t; width\n";
  filout << "\t\t.byte\t";
  filout << picHeight;  
  filout << "\t\t\t; height\n";    
  filout << "\t\t.word\tgfx." << shortname << ".data\n\n";
  filout << "gfx." << shortname << ".data:\n\t\t.byte\t%";


// *****************************************************************************
// Breakpoint go for MultiBlitGraphics or BlitGraphics
// *****************************************************************************

  if (tmp == 1 ) 
  {

// Skip forward to graphics start
  
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);

  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);

  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);

  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);

  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);

  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);

  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
  filin.get(tmpch);
 
  // Data extraction, copy all graphics data into buffer

  tmp=0;
       
  while (filin.get(tmpch))
  {
     buffer2[tmp]=tmpch;
  //   cout << int(tmpch) << " ";
     tmp++;
  }


  if (argc==3)
  {
     invert_arg=argv[2];
     if (invert_arg[0]=='-' && invert_arg[1]=='i')
     {
        for (int t=0; t<tmp;t++)
        {
           bintmp = int(buffer2[t]);
           if (bintmp & 0x80) buffer[t*8]='1';
           else buffer[t*8]='0';

           if (bintmp & 0x40) buffer[t*8+1]='1';
           else buffer[t*8+1]='0';

           if (bintmp & 0x20) buffer[t*8+2]='1';
           else buffer[t*8+2]='0';

           if (bintmp & 0x10) buffer[t*8+3]='1';
           else buffer[t*8+3]='0';

           if (bintmp & 0x08) buffer[t*8+4]='1';
           else buffer[t*8+4]='0';

           if (bintmp & 0x04) buffer[t*8+5]='1';
           else buffer[t*8+5]='0';

           if (bintmp & 0x02) buffer[t*8+6]='1';
           else buffer[t*8+6]='0';

           if (bintmp & 0x01) buffer[t*8+7]='1';
           else buffer[t*8+7]='0';
         }                  
     }
  }
  else                     
  {                   
                         
     for (int t=0; t<tmp;t++)
     {
         bintmp = int(buffer2[t]);
         if (bintmp & 0x80) buffer[t*8]='0';
         else buffer[t*8]='1';

         if (bintmp & 0x40) buffer[t*8+1]='0';
         else buffer[t*8+1]='1';

         if (bintmp & 0x20) buffer[t*8+2]='0';
         else buffer[t*8+2]='1';

         if (bintmp & 0x10) buffer[t*8+3]='0';
         else buffer[t*8+3]='1';

         if (bintmp & 0x08) buffer[t*8+4]='0';
         else buffer[t*8+4]='1';

         if (bintmp & 0x04) buffer[t*8+5]='0';
         else buffer[t*8+5]='1';

         if (bintmp & 0x02) buffer[t*8+6]='0';
         else buffer[t*8+6]='1';

         if (bintmp & 0x01) buffer[t*8+7]='0';
         else buffer[t*8+7]='1';
      }
  }

 // Erase extra data
 // heightTmp, widthTmp, buffer
 // Raw bitmap data is 32 * 1,2,3 or 4 bits (characters '0' or '1') wide
  
  if (widthTmp <=32) tmp=32;
  if (widthTmp >32 && widthTmp <=64) tmp = 64;
  if (widthTmp >64 && widthTmp <=96) tmp = 96;
  if (widthTmp >96) tmp = 128;
  
  bintmp=0;
  bintmp2=0;
 
  if (widthTmp == 32 || widthTmp == 63 || widthTmp == 96 || widthTmp == 128)
  {
    while (bintmp < tmp*heightTmp)
    {
          buffer3[bintmp]=buffer[bintmp];
          bintmp++;
    }             
    buffer3[bintmp+1]='S';   
  }
  else
  {
    while (bintmp < tmp*picHeight)
    {
          while (widthTmp > 0)
          {
                buffer3[bintmp2]=buffer[bintmp];
               // cout << buffer3[bintmp2];
                bintmp2++;
                bintmp++;
                widthTmp--;
          }       
          widthTmp=tmp - picWidth;
          while (widthTmp > 0)
          {
            widthTmp--;
            bintmp++;
          }
          widthTmp = picWidth;
    }
    buffer3[bintmp]='S';
  }
 
  bintmp=0;

// We now have all data in buffer3[], need to swap rows...

   tmp=0;
   heightTmp=picHeight;
   
   while (heightTmp >=1)
   {
           // sista raden: buffer3[0...picWidth-1]
           // näst sista raden: buffer3[picWidth...(2*picWidth)-1]
           // näst näst:  buffer3[2*picWidth...(3*picWidth)-1]
           // första: buffer3[(picHeight-1)*picWidth...(picHeight*picWidth)-1]
           
           while (tmp <= picWidth)
           {
               buffer[tmp+bintmp*picWidth]=buffer3[(heightTmp-1)*picWidth+tmp];
               tmp++;
           }
           heightTmp--;
           bintmp++;
           tmp=0;
   }
  

   bintmp=0;
// Put all data into correct form

   cout << "\nWriting data to file\n";
    
  while (bintmp < picWidth*picHeight)
  {  
      filout << buffer[bintmp];
      bitcounter++;
      
      if (bitcounter>7){
          bytecounter++;
          if (bytecounter==7){
             filout << "\n\t\t.byte\t%";
             bytecounter=0; 
             bitcounter=0;  
          }
          if (bytecounter!=0 && bintmp+1 < picWidth*picHeight){
             filout << ", %";
          }
          //cout << ".";
          bitcounter=0;          

      }    
      
      bintmp++;
  }   
 
  while (bitcounter <=7 && bitcounter >0)
  {
        filout << '0';
        bitcounter++;      
  }
  
  
          
  }
  else
  {
  // Skip forward to graphics start 22 x 4 bytes
  // REPLACE WITH OTHER CODE EVENTUALLY
  
  filin.get(tmpch);                       // Byte 31
  filin.get(tmpch);                       // Byte 32
  filin.get(tmpch);                       // Byte 33
  filin.get(tmpch);                       // Byte 34

  filin.get(tmpch);                       // Byte 35
  filin.get(tmpch);                       // Byte 36
  filin.get(tmpch);                       // Byte 37
  filin.get(tmpch);                       // Byte 38

  filin.get(tmpch);                       // Byte 39
  filin.get(tmpch);                       // Byte 40
  filin.get(tmpch);                       // Byte 41
  filin.get(tmpch);                       // Byte 42

  filin.get(tmpch);                       // Byte 43
  filin.get(tmpch);                       // Byte 44
  filin.get(tmpch);                       // Byte 45
  filin.get(tmpch);                       // Byte 46

  filin.get(tmpch);                       // Byte 47
  filin.get(tmpch);                       // Byte 48
  filin.get(tmpch);                       // Byte 49
  filin.get(tmpch);                       // Byte 50

  filin.get(tmpch);                       // Byte 51
  filin.get(tmpch);                       // Byte 52
  filin.get(tmpch);                       // Byte 53
  filin.get(tmpch);                       // Byte 54

  filin.get(tmpch);                       // Byte 55   first BGRr quadruple
  filin.get(tmpch);                       // Byte 56
  filin.get(tmpch);                       // Byte 57
  filin.get(tmpch);                       // Byte 58

  filin.get(tmpch);                       // Byte 59   second BGRr quad
  filin.get(tmpch);                       // Byte 60
  filin.get(tmpch);                       // Byte 61
  filin.get(tmpch);                       // Byte 62
 
  filin.get(tmpch);                       // Byte 63   third BGRr quad
  filin.get(tmpch);                       // Byte 64
  filin.get(tmpch);                       // Byte 65
  filin.get(tmpch);                       // Byte 66
  
  filin.get(tmpch);                       // Byte 67   fourth BGRr quad
  filin.get(tmpch);                       // Byte 68
  filin.get(tmpch);                       // Byte 69
  filin.get(tmpch);                       // Byte 70
  
  filin.get(tmpch);                       // Byte 71   fifth BGRr quad
  filin.get(tmpch);                       // Byte 72
  filin.get(tmpch);                       // Byte 73
  filin.get(tmpch);                       // Byte 74
  
  filin.get(tmpch);                       // Byte 75   sixth BGRr quad
  filin.get(tmpch);                       // Byte 76
  filin.get(tmpch);                       // Byte 77
  filin.get(tmpch);                       // Byte 78
  
  filin.get(tmpch);                       // Byte 79   seventh BGRr quad
  filin.get(tmpch);                       // Byte 80
  filin.get(tmpch);                       // Byte 81
  filin.get(tmpch);                       // Byte 82
  
  filin.get(tmpch);                       // Byte 83   eigth BGRr quad
  filin.get(tmpch);                       // Byte 84
  filin.get(tmpch);                       // Byte 85
  filin.get(tmpch);                       // Byte 86
  
  filin.get(tmpch);                       // Byte 87   ninth BGRr quad
  filin.get(tmpch);                       // Byte 88
  filin.get(tmpch);                       // Byte 89
  filin.get(tmpch);                       // Byte 90
  
  filin.get(tmpch);                       // Byte 91   tenth BGRr quad
  filin.get(tmpch);                       // Byte 92
  filin.get(tmpch);                       // Byte 93
  filin.get(tmpch);                       // Byte 94
  
  filin.get(tmpch);                       // Byte 95   eleventh BGRr quad
  filin.get(tmpch);                       // Byte 96
  filin.get(tmpch);                       // Byte 97
  filin.get(tmpch);                       // Byte 98
  
  filin.get(tmpch);                       // Byte 99   twelvth BGRr quad
  filin.get(tmpch);                       // Byte 100
  filin.get(tmpch);                       // Byte 101
  filin.get(tmpch);                       // Byte 102
  
  filin.get(tmpch);                       // Byte 103   thirteenth BGRr quad
  filin.get(tmpch);                       // Byte 104
  filin.get(tmpch);                       // Byte 105
  filin.get(tmpch);                       // Byte 106
  
  filin.get(tmpch);                       // Byte 108   fourteenth BGRr quad
  filin.get(tmpch);                       // Byte 109
  filin.get(tmpch);                       // Byte 110
  filin.get(tmpch);                       // Byte 111
  
  filin.get(tmpch);                       // Byte 112   fifteenth BGRr quad
  filin.get(tmpch);                       // Byte 113
  filin.get(tmpch);                       // Byte 114
  filin.get(tmpch);                       // Byte 115
  
  filin.get(tmpch);                       // Byte 116   sixteenth and last
  filin.get(tmpch);                       // Byte 117   BGRr quad
  filin.get(tmpch);                       // Byte 118
  filin.get(tmpch);                       // Byte 119
  
  // Data extraction, copy all graphics data into buffer, which is max 4096 bytes

  tmp=0;
       
  while (filin.get(tmpch))
  {
     buffer2[tmp]=tmpch;
     // cout << int(tmpch) << " ";
     tmp++;
  }
                      
  for (int t=0; t<tmp;t++)
  {
      bintmp = int(buffer2[t]);
      if ( ((bintmp & 0xF0)== 0x10) || ((bintmp & 0xF0)== 0x70) )            // Blue 
      {
      //      cout << "*7 ";
            buffer[t*4]='1';
            buffer[t*4+1]='0';
      }
      else if ((bintmp & 0xF0)== 0x20)       // Green
      {
            // cout << "*2 ";
            buffer[t*4]='0';       
            buffer[t*4+1]='0';
      }
      else if ((bintmp & 0xF0)== 0x30)       // Red
      {
          //  cout << "*3 ";           
            buffer[t*4]='0';
            buffer[t*4+1]='1';
      }
      else                                // Other colors => bkg
      {
           // cout << "*X ";
           buffer[t*4]='1';
           buffer[t*4+1]='1';
      }

      if ( ((bintmp & 0x0F)== 1) || ((bintmp & 0x0F)== 7) )            // Blue 
      {
            buffer[t*4+2]='1';
            buffer[t*4+3]='0';
      }
      else if ((bintmp & 0x0F)== 2)       // Green
      {
            buffer[t*4+2]='0';       
            buffer[t*4+3]='0';
      }
      else if ((bintmp & 0x0F)== 3)       // Red
      {
            buffer[t*4+2]='0';
            buffer[t*4+3]='1';
      }
      else                                // Other colors => bkg
      {
           buffer[t*4+2]='1';
           buffer[t*4+3]='1';
      }

  }
  buffer[4*tmp]='S';

 // Output all data in buffer
 
// cout << "\nThe first raw data in buffer:\n";
 
 tmp = 0; 
 
 while ( buffer[tmp]!='S' ) 
 {
      // cout << tmp << ":" << buffer[tmp] << "\t" ;
       // cout << buffer[tmp];
       tmp++;
      
 }

 // cout << buffer[tmp] << "\n\n" << tmp << "\n\n";

 // Erase extra data
 // heightTmp, widthTmp, buffer



  
  //  Set number of rounds to be able to erase extra data 
  //  Check which widths leaves bitmap data in multiples of 4 bytes
  
  if (widthTmp <=8) tmp=8;   //  One row of data is 4 bytes
  if (widthTmp >8 && widthTmp <=16 ) tmp = 16 ;  // 8 bytes
  if (widthTmp >16 && widthTmp <=24 ) tmp = 24;  // 12 bytes  etc.
  if (widthTmp >24 && widthTmp <=32 ) tmp = 32;  // 16 bytes
  if (widthTmp >32 && widthTmp <=40 ) tmp = 40;  // 20 bytes
  if (widthTmp >40 && widthTmp <=48 ) tmp = 48;  // 24 bytes
  if (widthTmp >48 && widthTmp <=56 ) tmp = 56;  // 28 bytes
  if (widthTmp >56 && widthTmp <=64 ) tmp = 64;  // 32 bytes
  if (widthTmp >64 && widthTmp <=72 ) tmp = 72;  // 36 bytes
  if (widthTmp >72 && widthTmp <=80 ) tmp = 80;  // 40 bytes
  if (widthTmp >80 && widthTmp <=88 ) tmp = 88;  // 44 bytes
  if (widthTmp >88 && widthTmp <=96 ) tmp = 96;  // 48 bytes
  if (widthTmp >96 && widthTmp <=104 ) tmp = 104;   // 52 bytes
  if (widthTmp >104 && widthTmp <=112 ) tmp = 112;  // 56 bytes
  if (widthTmp >112 && widthTmp <=120 ) tmp = 120;  // 60 bytes
  if (widthTmp >120 ) tmp = 128;                    // 64 bytes

  
  bintmp=0;
  bintmp2=0;
  
  // zero buffer3
  
  buffer3[0]='\0';
 
  if ( widthTmp == 8  || widthTmp ==  16  || widthTmp == 24  || widthTmp == 32  ||
     widthTmp ==  40  || widthTmp ==  48  || widthTmp == 56  || widthTmp == 64  ||
     widthTmp ==  72  || widthTmp ==  80  || widthTmp == 88  || widthTmp == 96  ||
     widthTmp ==  104 || widthTmp ==  112 || widthTmp == 120 || widthTmp == 128 )
  {
   // cout << "\n\nWidth of bitmap data is even 4 bytes.\n";          
    while (bintmp < picWidth*picHeight*2)   
    {
          buffer3[bintmp]=buffer[bintmp];
          // cout << buffer3[bintmp];
          bintmp++;
          
    }             
    buffer3[bintmp+1]='S';   
  }
  else
  {
   // cout << "\n\nWidth is not an even 4 bytes.\n";  
    while (bintmp < tmp*picHeight*2)           // Bytes in buffer is tmp*picHeight*2
    {                                          // Rinse to picWidth*picHeight*2
          while (widthTmp > 0)
          {
                buffer3[bintmp2]=buffer[bintmp];
                //cout << buffer3[bintmp2];
                bintmp2++;
                bintmp++;
                
                buffer3[bintmp2]=buffer[bintmp];
                //cout << buffer3[bintmp2];
                bintmp2++;
                bintmp++;
                
                widthTmp--;
          }       
          widthTmp=tmp*2 - picWidth*2;
          while (widthTmp > 0)                  // Skip padded data
          {
            widthTmp--;
            bintmp++;
          }
          widthTmp = picWidth;
    }
    buffer3[bintmp2+1]='S';
  }
 
  bintmp=0;

  // cout << "Data: " << bintmp2 << "\n\n";

// Print "before"-buffer   

// cout << "\n\nContents in buffer before row swapping:\n";


 tmp = 0; 
 
// cout << "\n\n";
 
 while ( buffer3[tmp]!='S' ) 
 {
       //cout << buffer3[tmp];
       tmp++;
      
 }


   // cout << "\n\n" << tmp << "\n\n";




// We now have all data in buffer3[], need to swap rows...

   tmp=0;
   heightTmp=picHeight;
   
   // cout << "Row swapping:\n\n";
   
   while (heightTmp >=1)
   {
           // sista raden: buffer3[0...2*picWidth-1]
           // näst sista raden: buffer3[2*picWidth...(4*picWidth)-1]
           // näst näst:  buffer3[4*picWidth...(6*picWidth)-1]
           // första: buffer3[(picHeight-1)*picWidth*2...(2*picHeight*picWidth)-1]
           
           while (tmp < picWidth*2)
           {
               buffer[tmp+bintmp*picWidth*2]=buffer3[(heightTmp-1)*2*picWidth+tmp];
               //cout << buffer3[(heightTmp-1)*2*picWidth+tmp];
               tmp++;
           }
           heightTmp--;
           bintmp++;
           tmp=0;
   }
   buffer[picWidth*picHeight*2+1]='S';

   bintmp=0;
   
   
// All data is in "buffer"
   
// Print "after"-buffer   

/*

 tmp = 0; 
 
 while ( buffer[tmp]!='S' ) 
 {
       cout << buffer[tmp];
       tmp++;
      
 }   

*/   
   
// Put all data into correct form

   cout << "\nWriting data to file\n";
    
  while (bintmp < picWidth*picHeight*2)
  {  
      filout << buffer[bintmp];
      bitcounter++;
      
      if (bitcounter>7){
          bytecounter++;
          if (bytecounter==7){
             filout << "\n\t\t.byte\t%";
             bytecounter=0; 
             bitcounter=0;  
          }
          if (bytecounter!=0 && bintmp+1 < picWidth*picHeight*2){
             filout << ", %";
          }
          //cout << ".";
          bitcounter=0;          

      }    
      
      bintmp++;
  }   
 
  while (bitcounter <=7 && bitcounter >0)
  {
        filout << '0';
        bitcounter++;      
  }
  
  }
    cout << "\n\n\n   Done!  Data stored in file:  ves_graphic.data.txt\n\n\n\n   ";
 
  filin.close();
  filout.close();
  cin >> ws;
  return 0;
}
