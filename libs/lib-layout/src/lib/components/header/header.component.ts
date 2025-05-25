import { CommonModule } from '@angular/common';
import { Component, input, model } from '@angular/core';

@Component({
  selector: 'lib-header',
  imports: [CommonModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.scss',
})
export class HeaderComponent {
  title = input<string>('');
  sideNavToggle = model<boolean>();

  onToggleSidenav(): void {
    this.sideNavToggle.set(!this.sideNavToggle());
  }
}
