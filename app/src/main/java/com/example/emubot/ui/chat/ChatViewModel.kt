package com.example.emubot.ui.chat

import android.os.Handler
import android.os.Looper
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.emubot.ui.chat.model.ChatMessage

class ChatViewModel : ViewModel() {

    private val _messages = MutableLiveData<List<ChatMessage>>()
    val messages: LiveData<List<ChatMessage>> = _messages

    private val _isTyping = MutableLiveData<Boolean>()
    val isTyping: LiveData<Boolean> = _isTyping

    private val messageList = mutableListOf<ChatMessage>()
    private val handler = Handler(Looper.getMainLooper())

    fun loadInitialMessages() {
        val initialMessages = listOf(
            ChatMessage(
                id = 1,
                text = "Hello! I'm EmuBot, your AI assistant. How can I help you today? ✨",
                isFromUser = false,
                timestamp = System.currentTimeMillis() - 60000
            )
        )
        
        messageList.addAll(initialMessages)
        _messages.value = messageList.toList()
    }

    fun sendMessage(text: String) {
        val userMessage = ChatMessage(
            id = messageList.size + 1,
            text = text,
            isFromUser = true,
            timestamp = System.currentTimeMillis()
        )
        
        messageList.add(userMessage)
        _messages.value = messageList.toList()
        
        // Simulate bot response
        simulateBotResponse(text)
    }

    private fun simulateBotResponse(userMessage: String) {
        _isTyping.value = true
        
        handler.postDelayed({
            val botResponse = generateBotResponse(userMessage)
            val botMessage = ChatMessage(
                id = messageList.size + 1,
                text = botResponse,
                isFromUser = false,
                timestamp = System.currentTimeMillis()
            )
            
            messageList.add(botMessage)
            _isTyping.value = false
            _messages.value = messageList.toList()
        }, 1500) // Simulate typing delay
    }

    private fun generateBotResponse(userMessage: String): String {
        return when {
            userMessage.contains("hello", ignoreCase = true) || 
            userMessage.contains("hi", ignoreCase = true) -> {
                "Hello there! 👋 I'm excited to help you. What would you like to know or do today?"
            }
            userMessage.contains("help", ignoreCase = true) -> {
                "I'm here to assist you! I can help with:\n• Answering questions 💡\n• Providing information 📚\n• Task automation 🤖\n• And much more!"
            }
            userMessage.contains("weather", ignoreCase = true) -> {
                "🌤️ I'd love to help with weather info! Currently, I don't have access to real-time weather data, but you can check your local weather app for the most accurate information."
            }
            userMessage.contains("thanks", ignoreCase = true) || 
            userMessage.contains("thank you", ignoreCase = true) -> {
                "You're very welcome! 😊 I'm always happy to help. Is there anything else you'd like to explore?"
            }
            userMessage.contains("features", ignoreCase = true) -> {
                "✨ EmuBot Features:\n• Smart conversations 💬\n• Glass UI design 🎨\n• Analytics dashboard 📊\n• Customizable settings ⚙️\n• And growing every day!"
            }
            else -> {
                val responses = listOf(
                    "That's interesting! Tell me more about that. 🤔",
                    "I understand. How can I help you with this? 💭",
                    "Great question! Let me think about that... 🧠",
                    "I'm learning from our conversation! What else would you like to explore? 🌟",
                    "Fascinating! I love learning new things from our chats. ✨"
                )
                responses.random()
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        handler.removeCallbacksAndMessages(null)
    }
}