package com.example.emubot.ui.features.model

data class FeatureItem(
    val id: Int,
    val title: String,
    val description: String,
    val icon: Int,
    val color: Int,
    val isComingSoon: Boolean = false,
    val progress: Int = 0,
    val category: String = "General"
)