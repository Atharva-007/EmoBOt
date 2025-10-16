package com.example.emubot.ui.features.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.emubot.databinding.ItemFeatureCardBinding
import com.example.emubot.ui.features.model.FeatureItem
import com.example.emubot.utils.WaterGlassAnimations

class FeatureAdapter(
    private val onFeatureClick: (FeatureItem) -> Unit
) : ListAdapter<FeatureItem, FeatureAdapter.FeatureViewHolder>(FeatureDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): FeatureViewHolder {
        val binding = ItemFeatureCardBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return FeatureViewHolder(binding, onFeatureClick)
    }

    override fun onBindViewHolder(holder: FeatureViewHolder, position: Int) {
        holder.bind(getItem(position))
        
        // Stagger entrance animations
        WaterGlassAnimations.createGlassCardEntrance(holder.itemView, position * 100L)
    }

    class FeatureViewHolder(
        private val binding: ItemFeatureCardBinding,
        private val onFeatureClick: (FeatureItem) -> Unit
    ) : RecyclerView.ViewHolder(binding.root) {

        fun bind(feature: FeatureItem) {
            binding.apply {
                featureTitle.text = feature.title
                featureDescription.text = feature.description
                featureIcon.setImageResource(feature.icon)
                
                // Set background color from feature color
                val context = root.context
                val color = context.getColor(feature.color)
                root.background.setTint(color and 0x40FFFFFF.toInt()) // Add transparency
                
                // Show coming soon badge
                comingSoonBadge.visibility = if (feature.isComingSoon) {
                    android.view.View.VISIBLE
                } else {
                    android.view.View.GONE
                }
                
                // Add shimmer effect for available features
                if (!feature.isComingSoon) {
                    WaterGlassAnimations.createGlassShimmerEffect(root)
                }
                
                // Setup click with water ripple effect
                root.setOnClickListener {
                    WaterGlassAnimations.createWaterRippleEffect(root) {
                        onFeatureClick(feature)
                    }
                }
                
                // Add spring bounce effect on long press
                root.setOnLongClickListener {
                    WaterGlassAnimations.createGlassBounceEffect(root)
                    true
                }
            }
        }
    }
}

private class FeatureDiffCallback : DiffUtil.ItemCallback<FeatureItem>() {
    override fun areItemsTheSame(oldItem: FeatureItem, newItem: FeatureItem): Boolean {
        return oldItem.id == newItem.id
    }

    override fun areContentsTheSame(oldItem: FeatureItem, newItem: FeatureItem): Boolean {
        return oldItem == newItem
    }
}