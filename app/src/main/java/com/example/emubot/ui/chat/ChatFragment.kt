package com.example.emubot.ui.chat

import android.animation.ObjectAnimator
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.DecelerateInterpolator
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.emubot.databinding.FragmentChatBinding
import com.example.emubot.ui.chat.adapter.ChatMessageAdapter
import com.example.emubot.ui.chat.model.ChatMessage

class ChatFragment : Fragment() {

    private var _binding: FragmentChatBinding? = null
    private val binding get() = _binding!!
    
    private lateinit var chatViewModel: ChatViewModel
    private lateinit var messageAdapter: ChatMessageAdapter

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        chatViewModel = ViewModelProvider(this)[ChatViewModel::class.java]
        
        _binding = FragmentChatBinding.inflate(inflater, container, false)
        val root: View = binding.root

        setupRecyclerView()
        setupInputArea()
        observeViewModel()
        setupAnimations()

        return root
    }

    private fun setupRecyclerView() {
        messageAdapter = ChatMessageAdapter()
        
        binding.chatRecyclerView.apply {
            layoutManager = LinearLayoutManager(context).apply {
                stackFromEnd = true
            }
            adapter = messageAdapter
        }
    }

    private fun setupInputArea() {
        binding.sendButton.setOnClickListener {
            val message = binding.messageInput.text.toString().trim()
            if (message.isNotEmpty()) {
                sendMessage(message)
                binding.messageInput.setText("")
            }
        }
        
        // Animate send button press
        binding.sendButton.setOnClickListener { view ->
            ObjectAnimator.ofFloat(view, "scaleX", 1f, 0.9f, 1f).apply {
                duration = 150
                start()
            }
            ObjectAnimator.ofFloat(view, "scaleY", 1f, 0.9f, 1f).apply {
                duration = 150
                start()
            }
            
            val message = binding.messageInput.text.toString().trim()
            if (message.isNotEmpty()) {
                sendMessage(message)
                binding.messageInput.setText("")
            }
        }
    }

    private fun observeViewModel() {
        chatViewModel.messages.observe(viewLifecycleOwner) { messages ->
            messageAdapter.submitList(messages) {
                if (messages.isNotEmpty()) {
                    binding.chatRecyclerView.scrollToPosition(messages.size - 1)
                }
            }
        }
        
        chatViewModel.isTyping.observe(viewLifecycleOwner) { isTyping ->
            binding.typingIndicator.visibility = if (isTyping) View.VISIBLE else View.GONE
        }
        
        // Load initial messages
        chatViewModel.loadInitialMessages()
    }

    private fun setupAnimations() {
        // Animate input area entrance
        binding.inputContainer.alpha = 0f
        binding.inputContainer.translationY = 100f
        
        ObjectAnimator.ofFloat(binding.inputContainer, "alpha", 0f, 1f).apply {
            duration = 600
            startDelay = 300
            start()
        }
        
        ObjectAnimator.ofFloat(binding.inputContainer, "translationY", 100f, 0f).apply {
            duration = 600
            startDelay = 300
            interpolator = DecelerateInterpolator()
            start()
        }

        // Animate chat header
        binding.chatHeader.alpha = 0f
        binding.chatHeader.translationY = -50f
        
        ObjectAnimator.ofFloat(binding.chatHeader, "alpha", 0f, 1f).apply {
            duration = 600
            startDelay = 100
            start()
        }
        
        ObjectAnimator.ofFloat(binding.chatHeader, "translationY", -50f, 0f).apply {
            duration = 600
            startDelay = 100
            interpolator = DecelerateInterpolator()
            start()
        }
    }

    private fun sendMessage(text: String) {
        chatViewModel.sendMessage(text)
        
        // Animate message sending
        binding.messageInput.animate()
            .scaleX(0.95f)
            .scaleY(0.95f)
            .setDuration(100)
            .withEndAction {
                binding.messageInput.animate()
                    .scaleX(1f)
                    .scaleY(1f)
                    .setDuration(100)
                    .start()
            }
            .start()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}