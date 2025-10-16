package com.example.emubot.ui.dashboard.adapter

import android.animation.ObjectAnimator
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.emubot.R
import com.example.emubot.databinding.ItemDashboardCardBinding
import com.example.emubot.ui.dashboard.model.DashboardCard

class DashboardCardAdapter(
    private val onCardClick: (DashboardCard) -> Unit
) : ListAdapter<DashboardCard, DashboardCardAdapter.CardViewHolder>(DashboardCardDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CardViewHolder {
        val binding = ItemDashboardCardBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return CardViewHolder(binding, onCardClick)
    }

    override fun onBindViewHolder(holder: CardViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    class CardViewHolder(
        private val binding: ItemDashboardCardBinding,
        private val onCardClick: (DashboardCard) -> Unit
    ) : RecyclerView.ViewHolder(binding.root) {

        fun bind(card: DashboardCard) {
            binding.apply {
                cardTitle.text = card.title
                cardSubtitle.text = card.subtitle
                cardIcon.setImageResource(card.iconRes)
                
                // Set gradient background based on card type
                val backgroundRes = when (card.gradient) {
                    DashboardCard.Gradient.PRIMARY -> R.drawable.glass_card_primary
                    DashboardCard.Gradient.SECONDARY -> R.drawable.glass_card_secondary
                    DashboardCard.Gradient.ACCENT -> R.drawable.glass_card_accent
                    DashboardCard.Gradient.NEUTRAL -> R.drawable.glass_card_dashboard
                }
                
                root.setBackgroundResource(backgroundRes)
                
                // Setup click animation
                root.setOnClickListener {
                    animateClick(root) {
                        onCardClick(card)
                    }
                }
            }
        }

        private fun animateClick(view: View, action: () -> Unit) {
            ObjectAnimator.ofFloat(view, "scaleX", 1f, 0.95f, 1f).apply {
                duration = 200
                start()
            }
            
            ObjectAnimator.ofFloat(view, "scaleY", 1f, 0.95f, 1f).apply {
                duration = 200
                start()
            }
            
            view.postDelayed(action, 100)
        }
    }
}

private class DashboardCardDiffCallback : DiffUtil.ItemCallback<DashboardCard>() {
    override fun areItemsTheSame(oldItem: DashboardCard, newItem: DashboardCard): Boolean {
        return oldItem.id == newItem.id
    }

    override fun areContentsTheSame(oldItem: DashboardCard, newItem: DashboardCard): Boolean {
        return oldItem == newItem
    }
}