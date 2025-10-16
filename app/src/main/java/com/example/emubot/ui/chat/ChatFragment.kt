package com.example.emubot.ui.chat

import android.animation.ObjectAnimator
import android.graphics.drawable.AnimationDrawable
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
import com.example.emubot.utils.WaterGlassAnimations

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

        setupAnimatedBackground()
        setupRecyclerView()
        setupInputArea()
        observeViewModel()
        setupAnimations()
        setupAIVisualization()

        return root
    }

    private fun setupAnimatedBackground() {
        // Start animated gradient background
        val animationDrawable = binding.root.background as? AnimationDrawable
        animationDrawable?.start()
        
        WaterGlassAnimations.createLiquidWaveEffect(binding.root)
        
        // Animate floating particles
        WaterGlassAnimations.createFloatingGlassEffect(binding.floatingParticle1)
        binding.floatingParticle2.postDelayed({
            WaterGlassAnimations.createFloatingGlassEffect(binding.floatingParticle2)
        }, 500)
        binding.floatingParticle3.postDelayed({
            WaterGlassAnimations.createFloatingGlassEffect(binding.floatingParticle3)
        }, 1000)
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
        // Enhanced send button with water ripple effect
        binding.sendButton.setOnClickListener {
            val message = binding.messageInput.text.toString().trim()
            if (message.isNotEmpty()) {
                WaterGlassAnimations.createWaterRippleEffect(binding.sendButton) {
                    sendMessage(message)
                    binding.messageInput.setText("")
                }
            }
        }
        
        // Voice button with glass bounce effect
        binding.voiceButton.setOnClickListener {
            WaterGlassAnimations.createGlassBounceEffect(binding.voiceButton)
            // TODO: Implement voice recognition
        }
        
        // Input field focus effects
        binding.messageInput.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                WaterGlassAnimations.createGlassShimmerEffect(binding.inputContainer)
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
            if (isTyping) {
                showTypingIndicator()
            } else {
                hideTypingIndicator()
            }
        }
        
        // Load initial messages
        chatViewModel.loadInitialMessages()
    }

    private fun setupAnimations() {
        // Animate input area entrance with glass effect
        WaterGlassAnimations.createGlassCardEntrance(binding.inputContainer, 300)
        
        // Animate AI header with glass effect
        WaterGlassAnimations.createGlassCardEntrance(binding.aiHeader, 0)
        
        // Chat area slide in
        binding.chatRecyclerView.alpha = 0f
        binding.chatRecyclerView.translationY = 100f
        binding.chatRecyclerView.animate()
            .alpha(1f)
            .translationY(0f)
            .setStartDelay(200)
            .setDuration(600)
            .setInterpolator(DecelerateInterpolator())
            .start()
    }

    private fun setupAIVisualization() {
        // AI avatar pulsing effect
        WaterGlassAnimations.createAIVisualizationEffect(binding.aiAvatar)
        WaterGlassAnimations.createAIVisualizationEffect(binding.aiPulseBackground)
        
        // Status indicator pulsing
        WaterGlassAnimations.createGlassShimmerEffect(binding.statusIndicator)
        
        // AI visualization bars animation
        animateVisualizationBars()
        
        // AI status text updates
        updateAIStatus()
    }

    private fun animateVisualizationBars() {
        val bars = listOf(
            binding.aiVisualizationBars.getChildAt(0),
            binding.aiVisualizationBars.getChildAt(1),
            binding.aiVisualizationBars.getChildAt(2),
            binding.aiVisualizationBars.getChildAt(3),
            binding.aiVisualizationBars.getChildAt(4)
        )
        
        bars.forEachIndexed { index, bar ->
            val animator = ObjectAnimator.ofFloat(bar, "scaleY", 0.3f, 1f, 0.5f, 1f, 0.3f).apply {
                duration = (1500 + (index * 200)).toLong()
                repeatCount = ObjectAnimator.INFINITE
                startDelay = index * 100L
            }
            animator.start()
        }
    }

    private fun updateAIStatus() {
        val statusMessages = listOf(
            "🧠 Processing your thoughts...",
            "✨ Generating intelligent response...",
            "🤖 AI neurons firing...",
            "💭 Analyzing context...",
            "🔮 Thinking creatively..."
        )
        
        var currentIndex = 0
        val handler = android.os.Handler(android.os.Looper.getMainLooper())
        
        val runnable = object : Runnable {
            override fun run() {
                WaterGlassAnimations.createTypewriterEffect(
                    binding.aiStatus,
                    statusMessages[currentIndex]
                )
                currentIndex = (currentIndex + 1) % statusMessages.size
                handler.postDelayed(this, 4000)
            }
        }
        
        handler.post(runnable)
    }

    private fun showTypingIndicator() {
        binding.typingContainer.visibility = View.VISIBLE
        WaterGlassAnimations.createGlassCardEntrance(binding.typingContainer)
        
        // Animate typing dots
        animateTypingDots()
    }

    private fun hideTypingIndicator() {
        binding.typingContainer.animate()
            .alpha(0f)
            .translationY(50f)
            .setDuration(300)
            .withEndAction {
                binding.typingContainer.visibility = View.GONE
                binding.typingContainer.alpha = 1f
                binding.typingContainer.translationY = 0f
            }
            .start()
    }

    private fun animateTypingDots() {
        val dots = listOf(binding.typingDot1, binding.typingDot2, binding.typingDot3)
        
        dots.forEachIndexed { index, dot ->
            val animator = ObjectAnimator.ofFloat(dot, "alpha", 0.3f, 1f, 0.3f).apply {
                duration = 600
                repeatCount = ObjectAnimator.INFINITE
                startDelay = index * 200L
            }
            animator.start()
        }
    }

    private fun sendMessage(text: String) {
        chatViewModel.sendMessage(text)
        
        // Enhanced message sending animation
        WaterGlassAnimations.createGlassBounceEffect(binding.messageInput)
    }

    override fun onResume() {
        super.onResume()
        // Restart background animation
        val animationDrawable = binding.root.background as? AnimationDrawable
        animationDrawable?.start()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}