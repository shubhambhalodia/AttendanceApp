import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
 final String title;
 final VoidCallback onTap;
 final bool loading;
  const RoundButton({super.key,required this.title, required this.onTap,this.loading=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple,
        ),
        child: Center(child: loading? CircularProgressIndicator(strokeWidth: 4,color: Colors.white,) :
        Text(title,style: TextStyle(color: Colors.white,),)),
      ),

    );
  }
}
