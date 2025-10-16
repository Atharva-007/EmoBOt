package com.example.emubot.ui.dashboard

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.emubot.R
import com.example.emubot.ui.dashboard.model.DashboardCard

class DashboardViewModel : ViewModel() {

    private val _dashboardCards = MutableLiveData<List<DashboardCard>>()
    val dashboardCards: LiveData<List<DashboardCard>> = _dashboardCards

    private val _stats = MutableLiveData<DashboardStats>()
    val stats: LiveData<DashboardStats> = _stats

    fun loadDashboardData() {
        val cards = listOf(
            DashboardCard(
                id = 1,
                title = "AI Chat",
                subtitle = "Start conversation",
                iconRes = R.drawable.ic_chat,
                type = DashboardCard.Type.CHAT,
                gradient = DashboardCard.Gradient.PRIMARY
            ),
            DashboardCard(
                id = 2,
                title = "Analytics",
                subtitle = "View insights",
                iconRes = R.drawable.ic_analytics,
                type = DashboardCard.Type.ANALYTICS,
                gradient = DashboardCard.Gradient.SECONDARY
            ),
            DashboardCard(
                id = 3,
                title = "Quick Actions",
                subtitle = "Fast commands",
                iconRes = R.drawable.ic_flash,
                type = DashboardCard.Type.QUICK_ACTION,
                gradient = DashboardCard.Gradient.ACCENT
            ),
            DashboardCard(
                id = 4,
                title = "Settings",
                subtitle = "Customize app",
                iconRes = R.drawable.ic_settings,
                type = DashboardCard.Type.SETTINGS,
                gradient = DashboardCard.Gradient.NEUTRAL
            )
        )
        
        _dashboardCards.value = cards
        
        _stats.value = DashboardStats(
            totalChats = 127,
            activeTime = "2h 34m",
            completedTasks = 23,
            aiAccuracy = 94.2f
        )
    }

    data class DashboardStats(
        val totalChats: Int,
        val activeTime: String,
        val completedTasks: Int,
        val aiAccuracy: Float
    )
}