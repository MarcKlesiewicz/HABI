import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { HeaderComponent } from '../components/header/header.component';
import { SideNavComponent } from '../components/side-nav/side-nav.component';

@Component({
  selector: 'lib-layout',
  imports: [CommonModule, SideNavComponent, HeaderComponent],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.scss',
})
export class LayoutComponent {}
