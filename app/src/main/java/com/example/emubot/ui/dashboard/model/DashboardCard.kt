package com.example.emubot.ui.dashboard.model

data class DashboardCard(
    val id: Int,
    val title: String,
    val subtitle: String,
    val iconRes: Int,
    val type: Type,
    val gradient: Gradient = Gradient.PRIMARY,
    val isActive: Boolean = true
) {
    enum class Type {
        CHAT,
        ANALYTICS,
        SETTINGS,
        QUICK_ACTION
    }
    
    enum class Gradient {
        PRIMARY,
        SECONDARY,
        ACCENT,
        NEUTRAL
    }
}