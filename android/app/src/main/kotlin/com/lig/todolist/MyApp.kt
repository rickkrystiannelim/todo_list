package com.lig.todolist

import io.flutter.app.FlutterApplication
import io.realm.Realm
import io.realm.RealmConfiguration

class MyApp : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        setupRealm()
    }

    /**
     * Setup Realm DB.
     */
    private fun setupRealm() {
        Realm.init(this)

        val config = RealmConfiguration.Builder()
                .name("todos.realm")
                .deleteRealmIfMigrationNeeded()
                .schemaVersion(0)
                .build()
        Realm.setDefaultConfiguration(config)
    }

}