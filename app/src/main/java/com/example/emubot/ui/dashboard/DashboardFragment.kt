package com.example.emubot.ui.dashboard

import android.animation.ObjectAnimator
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.DecelerateInterpolator
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.emubot.databinding.FragmentDashboardBinding
import com.example.emubot.ui.dashboard.adapter.DashboardCardAdapter
import com.example.emubot.ui.dashboard.model.DashboardCard

class DashboardFragment : Fragment() {

    private var _binding: FragmentDashboardBinding? = null
    private val binding get() = _binding!!
    
    private lateinit var dashboardViewModel: DashboardViewModel
    private lateinit var cardAdapter: DashboardCardAdapter

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        dashboardViewModel = ViewModelProvider(this)[DashboardViewModel::class.java]
        
        _binding = FragmentDashboardBinding.inflate(inflater, container, false)
        val root: View = binding.root

        setupUI()
        setupRecyclerView()
        observeViewModel()
        setupAnimations()

        return root
    }

    private fun setupUI() {
        binding.welcomeText.text = "Welcome back to EmuBot! ✨"
        binding.subtitleText.text = "Your AI assistant is ready to help you today"
        
        // Setup glass effect for welcome card
        binding.welcomeCard.alpha = 0f
        binding.welcomeCard.translationY = 50f
    }

    private fun setupRecyclerView() {
        cardAdapter = DashboardCardAdapter { card ->
            onCardClicked(card)
        }
        
        binding.dashboardRecyclerView.apply {
            layoutManager = GridLayoutManager(context, 2)
            adapter = cardAdapter
            itemAnimator = null // Disable default animations for custom ones
        }
    }

    private fun observeViewModel() {
        dashboardViewModel.dashboardCards.observe(viewLifecycleOwner) { cards ->
            cardAdapter.submitList(cards)
            animateCardsEntrance()
        }
        
        dashboardViewModel.loadDashboardData()
    }

    private fun setupAnimations() {
        // Animate welcome card
        ObjectAnimator.ofFloat(binding.welcomeCard, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 200
            start()
        }
        
        ObjectAnimator.ofFloat(binding.welcomeCard, "translationY", 50f, 0f).apply {
            duration = 800
            startDelay = 200
            interpolator = DecelerateInterpolator()
            start()
        }
        
        // Animate stats container
        binding.statsContainer.alpha = 0f
        binding.statsContainer.translationY = 100f
        
        ObjectAnimator.ofFloat(binding.statsContainer, "alpha", 0f, 1f).apply {
            duration = 600
            startDelay = 400
            start()
        }
        
        ObjectAnimator.ofFloat(binding.statsContainer, "translationY", 100f, 0f).apply {
            duration = 600
            startDelay = 400
            interpolator = DecelerateInterpolator()
            start()
        }
    }

    private fun animateCardsEntrance() {
        val recyclerView = binding.dashboardRecyclerView
        
        for (i in 0 until recyclerView.childCount) {
            val child = recyclerView.getChildAt(i)
            child.alpha = 0f
            child.translationY = 100f
            
            ObjectAnimator.ofFloat(child, "alpha", 0f, 1f).apply {
                duration = 500
                startDelay = 600L + (i * 100L)
                start()
            }
            
            ObjectAnimator.ofFloat(child, "translationY", 100f, 0f).apply {
                duration = 500
                startDelay = 600L + (i * 100L)
                interpolator = DecelerateInterpolator()
                start()
            }
        }
    }

    private fun onCardClicked(card: DashboardCard) {
        // Handle card clicks with animation
        when (card.type) {
            DashboardCard.Type.CHAT -> {
                // Navigate to chat
            }
            DashboardCard.Type.ANALYTICS -> {
                // Navigate to analytics
            }
            DashboardCard.Type.SETTINGS -> {
                // Navigate to settings
            }
            DashboardCard.Type.QUICK_ACTION -> {
                // Handle quick action
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}