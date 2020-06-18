package com.lig.todolist.model

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import java.lang.StringBuilder

open class TODO(
    var text: String = "",
    var status: Boolean = false,
    var photo: String = "",
    var notify: Boolean = false
) : RealmObject() {

    @PrimaryKey
    var id: Int = 0

    companion object {
        /**
         * Create an instance of [TODO] based from map.
         *
         * @param src Map source.
         * @return [TODO] instance.
         */
        fun from(src: HashMap<String, Any>) : TODO {
            val todo = TODO(
                    src["text"] as String,
                    src["status"] as Boolean,
                    src["photo"] as String,
                    src["notify"] as Boolean
            )
            todo.id = src["id"] as Int
            return todo
        }
    }

    /**
     * Create a [HashMap] instance of this class.
     *
     * @return [HashMap] instance of this class.
     */
    fun toMap() : HashMap<String, Any> = hashMapOf<String, Any>(
            "id" to id,
            "text" to text,
            "status" to status,
            "photo" to photo,
            "notify" to notify
    )

    override fun toString(): String {
        return StringBuilder()
                .append("TODO - ").append(id).append("\n")
                .append("text = ").append(text).append("\n")
                .append("status = ").append(status).append("\n")
                .append("photo = ").append(photo).append("\n")
                .append("notify = ").append(notify)
                .toString()
    }

}