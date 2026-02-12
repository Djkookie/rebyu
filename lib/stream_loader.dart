import 'package:flutter/material.dart';

StreamBuilder streamLoader(dataStream, callbackFunction) {

  return StreamBuilder(stream: dataStream, builder: (context, snapshot) {

    // ignore: avoid_print
    print('is Ready? $snapshot');

    if(snapshot.hasData && !snapshot.hasError && snapshot.data != null) {

      return callbackFunction(snapshot.data!);
    }

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

  });
}