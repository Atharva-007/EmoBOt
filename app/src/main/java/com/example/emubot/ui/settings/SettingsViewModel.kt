package com.example.emubot.ui.settings

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class SettingsViewModel : ViewModel() {

    private val _text = MutableLiveData<String>().apply {
        value = "⚙️ Settings Panel\n\nAdvanced glassmorphism settings interface coming soon with theme customization and preferences!"
    }
    val text: LiveData<String> = _text
}