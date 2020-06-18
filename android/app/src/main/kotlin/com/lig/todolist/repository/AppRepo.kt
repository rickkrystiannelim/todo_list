package com.lig.todolist.repository

import com.lig.todolist.model.TODO
import io.flutter.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.realm.Realm
import io.realm.Sort
import java.lang.Exception

class AppRepo {

    companion object {
        var _instance: AppRepo? = null

        /**
         * Get singleton instance of this class.
         *
         * @return [AppRepo] instance.
         */
        @Synchronized
        fun instance() : AppRepo {
            if (_instance == null) {
                _instance = AppRepo()
            }
            return _instance!!
        }
    }

    private val CHANNEL = "com.lig.todolist/realm"

    private val ACTION_GET_TODOS = "getTODOs"
    private val ACTION_SAVE_TODO = "save"
    private val ACTION_UPDATE_TODO = "update"
    private val ACTION_DELETE_TODO = "delete"
    private val ACTION_DELETE_ALL_TODOS = "deleteAll"

    private val RESULT_SUCCESS = 1
    private val RESULT_FAILED = 0

    private val _realm: Realm = Realm.getDefaultInstance()

    private constructor();

    /**
     * Setup method channel for communicating with flutter.
     *
     * @param flutterEngine
     */
    fun setupMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            Log.i("SHIT", "setupMethodChannel: ${call.method}  ,  ${call.arguments}")
            when (call.method) {
                ACTION_GET_TODOS -> {
                    result.success(getAll())
                }
                ACTION_SAVE_TODO -> {
                    val res = save(TODO.from(call.arguments as HashMap<String, Any>))
                    result.success(res)
                }
                ACTION_UPDATE_TODO -> {
                    val res = update(TODO.from(call.arguments as HashMap<String, Any>))
                    result.success(res)
                }
                ACTION_DELETE_TODO -> {
                    val res = delete(TODO.from(call.arguments as HashMap<String, Any>))
                    result.success(res)
                }
                ACTION_DELETE_ALL_TODOS -> {
                    result.success(deleteAll())
                }
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Get all [TODO] from Realm DB.
     *
     * @return List of [TODO] map.
     */
    private fun getAll() : List<HashMap<String, Any>> {
        val res = _realm.where(TODO::class.java).findAll().sort("id", Sort.DESCENDING)
        return res.map { it.toMap() }.toList();
    }

    /**
     * Save [todo] to Realm DB.
     *
     * @param todo Object to save.
     * @return [todo.id] if transaction was successful, otherwise, [RESULT_FAILED].
     */
    private fun save(todo: TODO) : Int {
        try {
            _realm.apply {
                beginTransaction()

                val currentIdNum: Number? = where(TODO::class.java).max("id")
                val nextId = if (currentIdNum == null) 1 else currentIdNum.toInt() + 1
                todo.id = nextId
                Log.d("SHIT", "SAVE: $todo")

                copyToRealmOrUpdate(todo)
                commitTransaction()
            }
        } catch (e: Exception) {
            Log.e("SHIT", "SAVE Exception: ${e.message}")
            return RESULT_FAILED
        }

        return todo.id
    }

    /**
     * Update [todo] from Realm DB.
     *
     * @param todo Object to update.
     * @return [todo.id] if transaction was successful, otherwise, [RESULT_FAILED].
     */
    private fun update(todo: TODO) : Int {
        try {
            _realm.apply {
                beginTransaction()
                Log.d("SHIT", "UPDATE: $todo")
                copyToRealmOrUpdate(todo)
                commitTransaction()
            }
        } catch (e: Exception) {
            Log.e("SHIT", "UPDATE Exception: ${e.message}")
            return RESULT_FAILED
        }

        return todo.id
    }

    /**
     * Delete [todo] from Realm DB.
     *
     * @param todo Object to delete.
     * @return [todo.id] if transaction was successful, otherwise, [RESULT_FAILED].
     */
    private fun delete(todo: TODO) : Int {
        try {
            _realm.apply {
                beginTransaction()
                val todo = where(TODO::class.java).equalTo("id", todo.id).findFirst()
                todo?.deleteFromRealm()
                commitTransaction()
            }
        } catch (e: Exception) {
            Log.e("SHIT", "DELETE Exception: ${e.message}")
            return RESULT_FAILED
        }

        return todo.id
    }

    /**
     * Delete all [TODO] from Realm DB.
     *
     * @return [RESULT_SUCCESS] if transaction was successful, otherwise, [RESULT_FAILED].
     */
    private fun deleteAll() : Int {
        try {
            _realm.apply {
                beginTransaction()
                where(TODO::class.java).findAll().deleteAllFromRealm()
                commitTransaction()
            }
        } catch (e: Exception) {
            Log.e("SHIT", "DELETE_ALL Exception: ${e.message}")
            return RESULT_FAILED
        }

        return RESULT_SUCCESS
    }

}