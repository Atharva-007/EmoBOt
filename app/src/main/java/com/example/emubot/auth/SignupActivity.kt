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
import com.example.emubot.databinding.ActivitySignupBinding

class SignupActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivitySignupBinding
    private var isNameValid = false
    private var isEmailValid = false
    private var isPasswordValid = false
    private var isConfirmPasswordValid = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySignupBinding.inflate(layoutInflater)
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
        animateInputField(binding.nameInputLayout, 600)
        animateInputField(binding.emailInputLayout, 700)
        animateInputField(binding.passwordInputLayout, 800)
        animateInputField(binding.confirmPasswordInputLayout, 900)
        animateButton(binding.signupButton, 1000)
        animateButton(binding.loginPrompt, 1200)
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
        binding.nameInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                validateName(s.toString())
                updateSignupButton()
            }
        })
        
        binding.emailInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                validateEmail(s.toString())
                updateSignupButton()
            }
        })
        
        binding.passwordInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                validatePassword(s.toString())
                validateConfirmPassword(binding.confirmPasswordInput.text.toString())
                updateSignupButton()
            }
        })
        
        binding.confirmPasswordInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                validateConfirmPassword(s.toString())
                updateSignupButton()
            }
        })
    }
    
    private fun validateName(name: String) {
        isNameValid = name.trim().length >= 2
        
        if (name.isNotEmpty() && !isNameValid) {
            binding.nameInputLayout.error = "Name must be at least 2 characters"
            animateErrorShake(binding.nameInputLayout)
        } else {
            binding.nameInputLayout.error = null
        }
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
    
    private fun validateConfirmPassword(confirmPassword: String) {
        val password = binding.passwordInput.text.toString()
        isConfirmPasswordValid = confirmPassword == password && confirmPassword.isNotEmpty()
        
        if (confirmPassword.isNotEmpty() && !isConfirmPasswordValid) {
            binding.confirmPasswordInputLayout.error = "Passwords do not match"
            animateErrorShake(binding.confirmPasswordInputLayout)
        } else {
            binding.confirmPasswordInputLayout.error = null
        }
    }
    
    private fun animateErrorShake(view: View) {
        ObjectAnimator.ofFloat(view, "translationX", 0f, 25f, -25f, 25f, -25f, 15f, -15f, 6f, -6f, 0f).apply {
            duration = 600
            interpolator = AccelerateDecelerateInterpolator()
            start()
        }
    }
    
    private fun updateSignupButton() {
        val isEnabled = isNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid
        binding.signupButton.isEnabled = isEnabled
        
        val alpha = if (isEnabled) 1f else 0.6f
        ObjectAnimator.ofFloat(binding.signupButton, "alpha", binding.signupButton.alpha, alpha).apply {
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
        
        binding.signupButton.setOnClickListener {
            if (isNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid) {
                animateButtonPress(it) {
                    performSignup()
                }
            }
        }
        
        binding.loginPrompt.setOnClickListener {
            animateButtonPress(it) {
                startActivity(Intent(this, LoginActivity::class.java))
                overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right)
            }
        }
    }
    
    private fun performSignup() {
        // Show loading animation
        binding.signupButton.text = ""
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
        binding.signupButton.text = "✓"
        binding.signupButton.setBackgroundColor(ContextCompat.getColor(this, R.color.auth_success))
        
        ObjectAnimator.ofFloat(binding.signupButton, "scaleX", 1f, 1.1f, 1f).apply {
            duration = 300
            start()
        }
        
        ObjectAnimator.ofFloat(binding.signupButton, "scaleY", 1f, 1.1f, 1f).apply {
            duration = 300
            start()
        }
        
        binding.root.postDelayed(onComplete, 500)
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