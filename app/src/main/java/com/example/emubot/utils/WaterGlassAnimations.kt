package com.example.emubot.utils

import android.animation.*
import android.graphics.drawable.AnimationDrawable
import android.view.View
import android.view.animation.*
import androidx.dynamicanimation.animation.DynamicAnimation
import androidx.dynamicanimation.animation.SpringAnimation
import androidx.dynamicanimation.animation.SpringForce
import androidx.interpolator.view.animation.FastOutSlowInInterpolator

object WaterGlassAnimations {

    /**
     * Creates a water ripple effect on button press
     */
    fun createWaterRippleEffect(view: View, onComplete: (() -> Unit)? = null) {
        val scaleX = PropertyValuesHolder.ofFloat(View.SCALE_X, 1f, 1.1f, 0.95f, 1.05f, 1f)
        val scaleY = PropertyValuesHolder.ofFloat(View.SCALE_Y, 1f, 1.1f, 0.95f, 1.05f, 1f)
        val alpha = PropertyValuesHolder.ofFloat(View.ALPHA, 1f, 0.8f, 1f)
        
        val animator = ObjectAnimator.ofPropertyValuesHolder(view, scaleX, scaleY, alpha).apply {
            duration = 600
            interpolator = FastOutSlowInInterpolator()
        }
        
        animator.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                onComplete?.invoke()
            }
        })
        
        animator.start()
    }

    /**
     * Creates floating glass orb animation
     */
    fun createFloatingGlassEffect(view: View) {
        val translationY = ObjectAnimator.ofFloat(view, "translationY", 0f, -20f, 0f, 10f, 0f).apply {
            duration = 4000
            repeatCount = ObjectAnimator.INFINITE
            interpolator = AccelerateDecelerateInterpolator()
        }
        
        val alpha = ObjectAnimator.ofFloat(view, "alpha", 0.3f, 0.7f, 0.3f, 0.5f, 0.3f).apply {
            duration = 3000
            repeatCount = ObjectAnimator.INFINITE
            interpolator = LinearInterpolator()
        }
        
        val rotation = ObjectAnimator.ofFloat(view, "rotation", 0f, 360f).apply {
            duration = 8000
            repeatCount = ObjectAnimator.INFINITE
            interpolator = LinearInterpolator()
        }
        
        AnimatorSet().apply {
            playTogether(translationY, alpha, rotation)
            start()
        }
    }

    /**
     * Creates spring-based glass bounce effect
     */
    fun createGlassBounceEffect(view: View, force: Float = SpringForce.DAMPING_RATIO_MEDIUM_BOUNCY) {
        val springX = SpringAnimation(view, DynamicAnimation.SCALE_X, 1f).apply {
            spring.dampingRatio = force
            spring.stiffness = SpringForce.STIFFNESS_LOW
        }
        
        val springY = SpringAnimation(view, DynamicAnimation.SCALE_Y, 1f).apply {
            spring.dampingRatio = force
            spring.stiffness = SpringForce.STIFFNESS_LOW
        }
        
        view.scaleX = 0.8f
        view.scaleY = 0.8f
        
        springX.start()
        springY.start()
    }

    /**
     * Creates liquid wave effect for backgrounds
     */
    fun createLiquidWaveEffect(view: View) {
        val drawable = view.background as? AnimationDrawable
        drawable?.start()
        
        // Add subtle movement
        val translateX = ObjectAnimator.ofFloat(view, "translationX", 0f, 5f, -5f, 0f).apply {
            duration = 6000
            repeatCount = ObjectAnimator.INFINITE
            interpolator = SineWaveInterpolator()
        }
        
        translateX.start()
    }

    /**
     * Creates glass shimmer effect
     */
    fun createGlassShimmerEffect(view: View) {
        val shimmer = ObjectAnimator.ofFloat(view, "alpha", 0.7f, 1f, 0.7f).apply {
            duration = 2000
            repeatCount = ObjectAnimator.INFINITE
            interpolator = AccelerateDecelerateInterpolator()
        }
        
        val scale = ObjectAnimator.ofFloat(view, "scaleX", 1f, 1.02f, 1f).apply {
            duration = 2000
            repeatCount = ObjectAnimator.INFINITE
            interpolator = AccelerateDecelerateInterpolator()
        }
        
        AnimatorSet().apply {
            playTogether(shimmer, scale)
            start()
        }
    }

    /**
     * Creates typewriter effect for AI chat
     */
    fun createTypewriterEffect(view: android.widget.TextView, text: String, onComplete: (() -> Unit)? = null) {
        view.text = ""
        var currentIndex = 0
        
        val handler = android.os.Handler(android.os.Looper.getMainLooper())
        val runnable = object : Runnable {
            override fun run() {
                if (currentIndex < text.length) {
                    view.text = text.substring(0, currentIndex + 1)
                    currentIndex++
                    handler.postDelayed(this, 50) // Typing speed
                } else {
                    onComplete?.invoke()
                }
            }
        }
        
        handler.post(runnable)
    }

    /**
     * Creates pulsing AI visualization effect
     */
    fun createAIVisualizationEffect(view: View) {
        val pulseScale = ObjectAnimator.ofFloat(view, "scaleX", 1f, 1.3f, 1f, 1.1f, 1f).apply {
            duration = 1500
            repeatCount = ObjectAnimator.INFINITE
            interpolator = AccelerateDecelerateInterpolator()
        }
        
        val pulseScaleY = ObjectAnimator.ofFloat(view, "scaleY", 1f, 1.3f, 1f, 1.1f, 1f).apply {
            duration = 1500
            repeatCount = ObjectAnimator.INFINITE
            interpolator = AccelerateDecelerateInterpolator()
        }
        
        val pulseAlpha = ObjectAnimator.ofFloat(view, "alpha", 0.5f, 1f, 0.5f, 0.8f, 0.5f).apply {
            duration = 1500
            repeatCount = ObjectAnimator.INFINITE
            interpolator = AccelerateDecelerateInterpolator()
        }
        
        AnimatorSet().apply {
            playTogether(pulseScale, pulseScaleY, pulseAlpha)
            start()
        }
    }

    /**
     * Custom sine wave interpolator for smooth motion
     */
    private class SineWaveInterpolator : Interpolator {
        override fun getInterpolation(input: Float): Float {
            return (kotlin.math.sin(input * kotlin.math.PI)).toFloat()
        }
    }

    /**
     * Creates morphing background effect
     */
    fun createMorphingBackgroundEffect(view: View) {
        val colorAnimation = ValueAnimator.ofArgb(
            0x66667eea.toInt(),
            0x66764ba2.toInt(),
            0x66f093fb.toInt(),
            0x664facfe.toInt(),
            0x6600f2fe.toInt(),
            0x66667eea.toInt()
        ).apply {
            duration = 8000
            repeatCount = ValueAnimator.INFINITE
            addUpdateListener { animator ->
                view.setBackgroundColor(animator.animatedValue as Int)
            }
        }
        
        colorAnimation.start()
    }

    /**
     * Creates glass card entrance animation
     */
    fun createGlassCardEntrance(view: View, delay: Long = 0) {
        view.alpha = 0f
        view.translationY = 100f
        view.scaleX = 0.8f
        view.scaleY = 0.8f
        
        view.animate()
            .alpha(1f)
            .translationY(0f)
            .scaleX(1f)
            .scaleY(1f)
            .setStartDelay(delay)
            .setDuration(800)
            .setInterpolator(FastOutSlowInInterpolator())
            .start()
    }
}