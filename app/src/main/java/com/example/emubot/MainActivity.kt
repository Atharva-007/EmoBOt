package com.example.emubot

import android.animation.ObjectAnimator
import android.os.Bundle
import android.view.Menu
import android.view.View
import android.view.animation.DecelerateInterpolator
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.example.emubot.databinding.ActivityMainBinding
import com.google.android.material.snackbar.Snackbar

class MainActivity : AppCompatActivity() {

    private lateinit var appBarConfiguration: AppBarConfiguration
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupGlassUI()
        setupNavigation()
        setupAnimations()
        setupFabActions()
    }

    private fun setupGlassUI() {
        // Enable edge-to-edge display
        WindowCompat.setDecorFitsSystemWindows(window, false)
        
        // Make status bar transparent
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        window.navigationBarColor = android.graphics.Color.TRANSPARENT
        
        // Set system UI visibility for immersive experience
        window.decorView.systemUiVisibility = 
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or 
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
            View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
    }

    private fun setupNavigation() {
        setSupportActionBar(binding.appBarMain.toolbar)
        
        val navController = findNavController(R.id.nav_host_fragment_content_main)
        
        // Define top level destinations
        appBarConfiguration = AppBarConfiguration(
            setOf(
                R.id.nav_dashboard, R.id.nav_chat, R.id.nav_analytics, R.id.nav_settings
            ), binding.drawerLayout
        )
        
        setupActionBarWithNavController(navController, appBarConfiguration)
        binding.navView.setupWithNavController(navController)
        
        // Apply glass effect to navigation view
        binding.navView.background = getDrawable(R.drawable.glass_navigation_background)
    }

    private fun setupAnimations() {
        // Animate toolbar entrance
        binding.appBarMain.toolbar.alpha = 0f
        binding.appBarMain.toolbar.translationY = -100f
        
        ObjectAnimator.ofFloat(binding.appBarMain.toolbar, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 200
            start()
        }
        
        ObjectAnimator.ofFloat(binding.appBarMain.toolbar, "translationY", -100f, 0f).apply {
            duration = 800
            startDelay = 200
            interpolator = DecelerateInterpolator()
            start()
        }

        // Animate FAB entrance
        binding.appBarMain.fab.alpha = 0f
        binding.appBarMain.fab.scaleX = 0.5f
        binding.appBarMain.fab.scaleY = 0.5f
        
        ObjectAnimator.ofFloat(binding.appBarMain.fab, "alpha", 0f, 1f).apply {
            duration = 600
            startDelay = 600
            start()
        }
        
        ObjectAnimator.ofFloat(binding.appBarMain.fab, "scaleX", 0.5f, 1f).apply {
            duration = 600
            startDelay = 600
            interpolator = DecelerateInterpolator()
            start()
        }
        
        ObjectAnimator.ofFloat(binding.appBarMain.fab, "scaleY", 0.5f, 1f).apply {
            duration = 600
            startDelay = 600
            interpolator = DecelerateInterpolator()
            start()
        }

        // Animate navigation drawer
        binding.navView.alpha = 0f
        binding.navView.translationX = -200f
        
        ObjectAnimator.ofFloat(binding.navView, "alpha", 0f, 1f).apply {
            duration = 800
            startDelay = 400
            start()
        }
        
        ObjectAnimator.ofFloat(binding.navView, "translationX", -200f, 0f).apply {
            duration = 800
            startDelay = 400
            interpolator = DecelerateInterpolator()
            start()
        }
    }

    private fun setupFabActions() {
        binding.appBarMain.fab.setOnClickListener { view ->
            // Animate FAB press
            ObjectAnimator.ofFloat(view, "scaleX", 1f, 0.9f, 1f).apply {
                duration = 200
                start()
            }
            
            ObjectAnimator.ofFloat(view, "scaleY", 1f, 0.9f, 1f).apply {
                duration = 200
                start()
            }
            
            // Show glass snackbar
            Snackbar.make(view, "✨ EmuBot Assistant Ready!", Snackbar.LENGTH_LONG)
                .setAction("Chat") { 
                    // Navigate to chat
                    findNavController(R.id.nav_host_fragment_content_main)
                        .navigate(R.id.nav_chat)
                }
                .setActionTextColor(getColor(R.color.ai_accent))
                .setBackgroundTint(getColor(R.color.glass_background))
                .setTextColor(getColor(R.color.text_primary_glass))
                .setAnchorView(R.id.fab)
                .show()
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main, menu)
        return true
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment_content_main)
        return navController.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
    }
}