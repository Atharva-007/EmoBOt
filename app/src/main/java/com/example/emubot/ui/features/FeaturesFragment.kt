package com.example.emubot.ui.features

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.GridLayoutManager
import com.example.emubot.R
import com.example.emubot.databinding.FragmentFeaturesBinding
import com.example.emubot.ui.features.adapter.FeatureAdapter
import com.example.emubot.ui.features.model.FeatureItem
import com.example.emubot.utils.WaterGlassAnimations

class FeaturesFragment : Fragment() {

    private var _binding: FragmentFeaturesBinding? = null
    private val binding get() = _binding!!
    
    private lateinit var featureAdapter: FeatureAdapter

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentFeaturesBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        setupAnimatedBackground()
        setupFeatureGrid()
        animateEntrance()
    }

    private fun setupAnimatedBackground() {
        // Start animated gradient background
        WaterGlassAnimations.createMorphingBackgroundEffect(binding.root)
        
        // Add floating glass effects
        WaterGlassAnimations.createFloatingGlassEffect(binding.headerContainer)
        
        // AI visualization effect
        WaterGlassAnimations.createAIVisualizationEffect(binding.aiVisualization)
    }

    private fun setupFeatureGrid() {
        val features = listOf(
            FeatureItem(
                id = 1,
                title = "AI Chat Assistant",
                description = "Intelligent conversations with context awareness and natural language processing",
                icon = R.drawable.ic_chat,
                color = R.color.ai_primary,
                isComingSoon = false
            ),
            FeatureItem(
                id = 2,
                title = "Advanced Analytics",
                description = "Real-time insights and visual data representation with interactive charts",
                icon = R.drawable.ic_analytics,
                color = R.color.ai_secondary,
                isComingSoon = false
            ),
            FeatureItem(
                id = 3,
                title = "Smart Automation",
                description = "Automate repetitive tasks with AI-powered workflow management",
                icon = R.drawable.ic_automation,
                color = R.color.ai_accent,
                isComingSoon = true
            ),
            FeatureItem(
                id = 4,
                title = "Voice Commands",
                description = "Control the app with natural voice interactions and speech recognition",
                icon = R.drawable.ic_voice,
                color = R.color.ai_success,
                isComingSoon = true
            ),
            FeatureItem(
                id = 5,
                title = "Personalization",
                description = "Customizable themes, layouts, and AI personality settings",
                icon = R.drawable.ic_personalize,
                color = R.color.ai_warning,
                isComingSoon = false
            ),
            FeatureItem(
                id = 6,
                title = "Cloud Sync",
                description = "Seamless synchronization across devices with encrypted cloud storage",
                icon = R.drawable.ic_cloud,
                color = R.color.ai_info,
                isComingSoon = true
            ),
            FeatureItem(
                id = 7,
                title = "Real-time Collaboration",
                description = "Share conversations and collaborate with team members in real-time",
                icon = R.drawable.ic_collaboration,
                color = R.color.gradient_start,
                isComingSoon = true
            ),
            FeatureItem(
                id = 8,
                title = "AI Learning Mode",
                description = "Continuous learning from interactions to provide better responses",
                icon = R.drawable.ic_learning,
                color = R.color.gradient_end,
                isComingSoon = false
            )
        )

        featureAdapter = FeatureAdapter { feature ->
            WaterGlassAnimations.createWaterRippleEffect(binding.root) {
                navigateToFeatureDetail(feature)
            }
        }

        binding.featuresRecyclerView.apply {
            layoutManager = GridLayoutManager(context, 2)
            adapter = featureAdapter
        }

        featureAdapter.submitList(features)
    }

    private fun navigateToFeatureDetail(feature: FeatureItem) {
        if (!feature.isComingSoon) {
            when (feature.id) {
                1 -> findNavController().navigate(R.id.nav_chat)
                2 -> findNavController().navigate(R.id.nav_analytics)
                5 -> findNavController().navigate(R.id.nav_settings)
                8 -> findNavController().navigate(R.id.nav_dashboard)
            }
        }
    }

    private fun animateEntrance() {
        // Header animation
        WaterGlassAnimations.createGlassCardEntrance(binding.headerContainer, 0)
        
        // Title typewriter effect
        WaterGlassAnimations.createTypewriterEffect(
            binding.titleText,
            "🚀 Explore EmuBot Features"
        )
        
        // Subtitle with delay
        binding.subtitleText.postDelayed({
            WaterGlassAnimations.createTypewriterEffect(
                binding.subtitleText,
                "Discover the power of AI-driven assistance with advanced glassmorphism design"
            )
        }, 1000)
        
        // Shimmer effect on grid
        binding.featuresRecyclerView.postDelayed({
            WaterGlassAnimations.createGlassShimmerEffect(binding.featuresRecyclerView)
        }, 1500)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}