import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStyle {
//Field
//กำหนดค่าสีต่าง ๆ

  Color mainColor = const Color(0xFFECEDF3);
  Color textColor = const Color(0xFF101546);
  Color barColor = const Color(0xFF4CD132);
  Color black1 = const Color(0xFF0A0A04);

  Color text2Color = const Color(0xFF101546);

  Color red1 = const Color(0xFF420505);
  Color color2 = const Color(0xFF2C2B41);
  Color color3 = const Color(0xFF525738);
  Color red2 = const Color(0xFF7E217E);
  Color color5 = const Color(0xFF728ECA);
  Color color6 = const Color(0xFF8FA9E0);
  Color color7 = const Color(0xFF8FA9E0);
  Color color9 = const Color(0xFF8FA9E0);
  Color color8 = const Color(0xFF8FA9E0);
  Color colorGrey = const Color(0xFF27273D);
  Color colorblack = const Color(0xFF19191B);
  Color colorWhite = const Color(0xFFE1EBEB);

  Color colorGrey1 = const Color(0xFFC6D1DD);
  Color colorGrey2 = const Color(0xFF647C97);
  Color colorGrey3 = const Color(0xFF647C97);
  Color colorGrey4 = const Color(0xFF647C97);
  Color colorGrey5 = const Color(0xFF647C97);
  Color colorGrey6 = const Color(0xFF647C97);
  Color colorGrey7 = const Color(0xFF647C97);
  Color colorGrey8 = const Color(0xFF1F262E);
  Color colorGrey9 = const Color(0xFF0F1720);

  Color deepPurple900 = const Color(0xFF510EBD);
  Color blue600 = const Color(0xFF2C61C4);
  Color blue900 = const Color(0xFF4B618A);
  Color red100 = const Color(0xFF4B618A);

  Color greent1 = const Color(0xFF4CD132);

  Color c1 = const Color(0xFF42A5F5);
  Color c2 = const Color(0xFF42A5F5);
  Color c3 = const Color(0xFF42A5F5);
  Color yellow1 = const Color(0xFF96BE4A);

  Color b1 = const Color(0xFF06253F);

  Color c5 = const Color(0xFFE4EAF0); // fully transparent white (invisible)
  Color c6 = const Color(0xFFFFFFFF); // fully opaque white (visible)

  TextStyle h2Style = GoogleFonts.trirong(
    textStyle: TextStyle(
      color: Color(0xFF101546),
      fontSize: 24.0,
    ),
  );

TextStyle h10Style = GoogleFonts.trirong(
  textStyle: TextStyle(
    color: Color(0xFF101546),
    fontSize: 10.0,
  ),
);

  TextStyle h12Style = GoogleFonts.trirong(
    textStyle: TextStyle(
      color: Color(0xFF101546),
      fontSize: 12.0,
    ),
  );

  TextStyle h11Style = GoogleFonts.trirong(
  textStyle: TextStyle(
    color: Color(0xFF101546),
    fontSize: 11.0,
  ),
);





  TextStyle h16Greenstyle = GoogleFonts.trirong(
  textStyle: TextStyle(
    color: Color(0xFF1B4607),
    fontSize: 16.0,
  ),
);



  TextStyle h12Stylew = GoogleFonts.trirong(
  textStyle: TextStyle(
    color: Color(0xFF8487A0),
    fontSize: 12.0,
  ),
);



  TextStyle h14Style = GoogleFonts.trirong(
    textStyle: TextStyle(
      color: Color(0xFF101546),
      fontSize: 14.0,
    ),
  );

   TextStyle h14Stylew = GoogleFonts.trirong(
   textStyle: TextStyle(
     color: Color(0xFFD1D3E0),
     fontSize: 14.0,
   ),
 );

  TextStyle h18Style = GoogleFonts.trirong(
    textStyle: TextStyle(
      color: Color(0xFF101546),
      fontSize: 18.0,
    ),
  );

  TextStyle d2Style = GoogleFonts.maitree(
    textStyle: TextStyle(
      color: Color(0xFF0B0E27),
      fontSize: 24.0,
    ),
  );

TextStyle d314Style = GoogleFonts.sarabun(
  textStyle: TextStyle(
    color: Color(0xFF0B0E27),
    fontSize: 14.0,
  ),
);



  Widget showProcess = Center(
    child: CircularProgressIndicator(),
  );


Widget showLogo2() {
  return Container(
    height: 80.0,
    child: Image.asset('images/logo12.png'),
  );
}



//Method เวลาเรียกใช้ให้ MyStype()
  MyStyle();
}
