import { CommonModule } from '@angular/common';
import { Component, input } from '@angular/core';

@Component({
  selector: 'flash-card',
  imports: [CommonModule],
  templateUrl: './flash-card.component.html',
  styleUrl: './flash-card.component.scss',
})
export class FlashCardComponent {
  mainText = input.required<string>();
  category = input.required<string>();
  icon = input.required<string>();
  iconColor = input.required<string>();
  iconBgColor = input.required<string>();
}
