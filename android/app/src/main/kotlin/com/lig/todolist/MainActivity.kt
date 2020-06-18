package com.lig.todolist

import com.lig.todolist.repository.AppRepo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AppRepo.instance().setupMethodChannel(flutterEngine)
    }

}
