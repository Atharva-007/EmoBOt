package com.example.emubot.auth

import android.animation.ObjectAnimator
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.animation.DecelerateInterpolator
import androidx.appcompat.app.AppCompatActivity
import com.example.emubot.databinding.ActivityWelcomeBinding

class WelcomeActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityWelcomeBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityWelcomeBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupUI()
        setupAnimations()
        setupClickListeners()
    }
    
    private fun setupUI() {
        // Make status bar transparent
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        window.decorView.systemUiVisibility = 
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
    }
    
    private fun setupAnimations() {
        // Animate logo
        binding.logoImageView.alpha = 0f
        binding.logoImageView.scaleX = 0.5f
        binding.logoImageView.scaleY = 0.5f
        
        ObjectAnimator.ofFloat(binding.logoImageView, "alpha", 0f, 1f).apply {
            duration = 1000
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.logoImageView, "scaleX", 0.5f, 1f).apply {
            duration = 1000
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.logoImageView, "scaleY", 0.5f, 1f).apply {
            duration = 1000
            interpolator = DecelerateInterpolator()
            start()
        }
        
        // Animate welcome text
        binding.welcomeText.translationY = 100f
        binding.welcomeText.alpha = 0f
        
        ObjectAnimator.ofFloat(binding.welcomeText, "translationY", 100f, 0f).apply {
            duration = 800
            startDelay = 300
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.welcomeText, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 300
            start()
        }
        
        // Animate subtitle
        binding.subtitleText.translationY = 100f
        binding.subtitleText.alpha = 0f
        
        ObjectAnimator.ofFloat(binding.subtitleText, "translationY", 100f, 0f).apply {
            duration = 800
            startDelay = 500
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.subtitleText, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 500
            start()
        }
        
        // Animate buttons
        binding.loginButton.translationY = 150f
        binding.loginButton.alpha = 0f
        binding.signupButton.translationY = 150f
        binding.signupButton.alpha = 0f
        
        ObjectAnimator.ofFloat(binding.loginButton, "translationY", 150f, 0f).apply {
            duration = 800
            startDelay = 700
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.loginButton, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 700
            start()
        }
        
        ObjectAnimator.ofFloat(binding.signupButton, "translationY", 150f, 0f).apply {
            duration = 800
            startDelay = 900
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.signupButton, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 900
            start()
        }
    }
    
    private fun setupClickListeners() {
        binding.loginButton.setOnClickListener {
            animateButtonPress(it) {
                startActivity(Intent(this, LoginActivity::class.java))
            }
        }
        
        binding.signupButton.setOnClickListener {
            animateButtonPress(it) {
                startActivity(Intent(this, SignupActivity::class.java))
            }
        }
    }
    
    private fun animateButtonPress(view: View, action: () -> Unit) {
        ObjectAnimator.ofFloat(view, "scaleX", 1f, 0.95f, 1f).apply {
            duration = 150
            start()
        }
        
        ObjectAnimator.ofFloat(view, "scaleY", 1f, 0.95f, 1f).apply {
            duration = 150
            start()
        }
        
        view.postDelayed(action, 150)
    }
}