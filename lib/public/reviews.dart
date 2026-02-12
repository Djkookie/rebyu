import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                child: Icon(
                  Icons.image,
                ),
              ),

              const Text(
                'LOrem ipsum dolor sit amit',
                textAlign: TextAlign.center,
              ),

              SizedBox(
                height: 100,
                child:  ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Text('text $index');
                  }
                ),
              )
             
              
              
            ],
          )
        )
      )
    );
  }
}