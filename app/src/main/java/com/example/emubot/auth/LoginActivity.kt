package com.example.emubot.auth

import android.animation.ObjectAnimator
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Patterns
import android.view.View
import android.view.animation.AccelerateDecelerateInterpolator
import android.view.animation.DecelerateInterpolator
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.example.emubot.MainActivity
import com.example.emubot.R
import com.example.emubot.databinding.ActivityLoginBinding

class LoginActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityLoginBinding
    private var isEmailValid = false
    private var isPasswordValid = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupUI()
        setupAnimations()
        setupInputValidation()
        setupClickListeners()
    }
    
    private fun setupUI() {
        // Make status bar transparent
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        window.decorView.systemUiVisibility = 
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
    }
    
    private fun setupAnimations() {
        // Initial state - hide all views
        binding.glassContainer.alpha = 0f
        binding.glassContainer.translationY = 100f
        binding.titleText.alpha = 0f
        binding.titleText.translationY = -50f
        binding.backButton.alpha = 0f
        binding.backButton.translationX = -50f
        
        // Animate container entrance
        ObjectAnimator.ofFloat(binding.glassContainer, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 200
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.glassContainer, "translationY", 100f, 0f).apply {
            duration = 800
            startDelay = 200
            interpolator = DecelerateInterpolator()
            start()
        }
        
        // Animate title
        ObjectAnimator.ofFloat(binding.titleText, "alpha", 0f, 1f).apply {
            duration = 600
            startDelay = 400
            start()
        }
        
        ObjectAnimator.ofFloat(binding.titleText, "translationY", -50f, 0f).apply {
            duration = 600
            startDelay = 400
            interpolator = DecelerateInterpolator()
            start()
        }
        
        // Animate back button
        ObjectAnimator.ofFloat(binding.backButton, "alpha", 0f, 1f).apply {
            duration = 600
            startDelay = 300
            start()
        }
        
        ObjectAnimator.ofFloat(binding.backButton, "translationX", -50f, 0f).apply {
            duration = 600
            startDelay = 300
            interpolator = DecelerateInterpolator()
            start()
        }
        
        // Animate input fields with stagger
        animateInputField(binding.emailInputLayout, 600)
        animateInputField(binding.passwordInputLayout, 800)
        animateButton(binding.loginButton, 1000)
        animateButton(binding.signupPrompt, 1200)
    }
    
    private fun animateInputField(view: View, delay: Long) {
        view.alpha = 0f
        view.translationX = 50f
        
        ObjectAnimator.ofFloat(view, "alpha", 0f, 1f).apply {
            duration = 500
            startDelay = delay
            start()
        }
        
        ObjectAnimator.ofFloat(view, "translationX", 50f, 0f).apply {
            duration = 500
            startDelay = delay
            interpolator = DecelerateInterpolator()
            start()
        }
    }
    
    private fun animateButton(view: View, delay: Long) {
        view.alpha = 0f
        view.scaleX = 0.8f
        view.scaleY = 0.8f
        
        ObjectAnimator.ofFloat(view, "alpha", 0f, 1f).apply {
            duration = 400
            startDelay = delay
            start()
        }
        
        ObjectAnimator.ofFloat(view, "scaleX", 0.8f, 1f).apply {
            duration = 400
            startDelay = delay
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(view, "scaleY", 0.8f, 1f).apply {
            duration = 400
            startDelay = delay
            interpolator = DecelerateInterpolator()
            start()
        }
    }
    
    private fun setupInputValidation() {
        binding.emailInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                validateEmail(s.toString())
                updateLoginButton()
            }
        })
        
        binding.passwordInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                validatePassword(s.toString())
                updateLoginButton()
            }
        })
    }
    
    private fun validateEmail(email: String) {
        isEmailValid = Patterns.EMAIL_ADDRESS.matcher(email).matches()
        
        if (email.isNotEmpty() && !isEmailValid) {
            binding.emailInputLayout.error = "Invalid email format"
            animateErrorShake(binding.emailInputLayout)
        } else {
            binding.emailInputLayout.error = null
        }
    }
    
    private fun validatePassword(password: String) {
        isPasswordValid = password.length >= 6
        
        if (password.isNotEmpty() && !isPasswordValid) {
            binding.passwordInputLayout.error = "Password must be at least 6 characters"
            animateErrorShake(binding.passwordInputLayout)
        } else {
            binding.passwordInputLayout.error = null
        }
    }
    
    private fun animateErrorShake(view: View) {
        ObjectAnimator.ofFloat(view, "translationX", 0f, 25f, -25f, 25f, -25f, 15f, -15f, 6f, -6f, 0f).apply {
            duration = 600
            interpolator = AccelerateDecelerateInterpolator()
            start()
        }
    }
    
    private fun updateLoginButton() {
        val isEnabled = isEmailValid && isPasswordValid
        binding.loginButton.isEnabled = isEnabled
        
        val alpha = if (isEnabled) 1f else 0.6f
        ObjectAnimator.ofFloat(binding.loginButton, "alpha", binding.loginButton.alpha, alpha).apply {
            duration = 300
            start()
        }
    }
    
    private fun setupClickListeners() {
        binding.backButton.setOnClickListener {
            animateButtonPress(it) {
                finish()
                overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right)
            }
        }
        
        binding.loginButton.setOnClickListener {
            if (isEmailValid && isPasswordValid) {
                animateButtonPress(it) {
                    performLogin()
                }
            }
        }
        
        binding.signupPrompt.setOnClickListener {
            animateButtonPress(it) {
                startActivity(Intent(this, SignupActivity::class.java))
                overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left)
            }
        }
        
        binding.forgotPasswordButton.setOnClickListener {
            animateButtonPress(it) {
                // TODO: Implement forgot password
                showMessage("Forgot password feature coming soon!")
            }
        }
    }
    
    private fun performLogin() {
        // Show loading animation
        binding.loginButton.text = ""
        binding.progressBar.visibility = View.VISIBLE
        
        // Simulate API call
        binding.root.postDelayed({
            // Success animation
            animateSuccess {
                startActivity(Intent(this, MainActivity::class.java))
                finish()
            }
        }, 2000)
    }
    
    private fun animateSuccess(onComplete: () -> Unit) {
        binding.progressBar.visibility = View.GONE
        binding.loginButton.text = "✓"
        binding.loginButton.setBackgroundColor(ContextCompat.getColor(this, R.color.auth_success))
        
        ObjectAnimator.ofFloat(binding.loginButton, "scaleX", 1f, 1.1f, 1f).apply {
            duration = 300
            start()
        }
        
        ObjectAnimator.ofFloat(binding.loginButton, "scaleY", 1f, 1.1f, 1f).apply {
            duration = 300
            start()
        }
        
        binding.root.postDelayed(onComplete, 500)
    }
    
    private fun showMessage(message: String) {
        // TODO: Implement snackbar or toast
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