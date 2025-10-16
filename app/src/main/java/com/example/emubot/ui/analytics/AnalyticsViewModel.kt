package com.example.emubot.ui.analytics

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class AnalyticsViewModel : ViewModel() {

    private val _text = MutableLiveData<String>().apply {
        value = "📊 Analytics Dashboard\n\nGlassmorphism analytics coming soon with beautiful charts and insights!"
    }
    val text: LiveData<String> = _text
}