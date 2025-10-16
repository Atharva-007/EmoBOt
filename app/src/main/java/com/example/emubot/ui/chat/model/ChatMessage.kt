package com.example.emubot.ui.chat.model

import java.text.SimpleDateFormat
import java.util.*

data class ChatMessage(
    val id: Int,
    val text: String,
    val isFromUser: Boolean,
    val timestamp: Long
) {
    fun getFormattedTime(): String {
        val formatter = SimpleDateFormat("HH:mm", Locale.getDefault())
        return formatter.format(Date(timestamp))
    }
}