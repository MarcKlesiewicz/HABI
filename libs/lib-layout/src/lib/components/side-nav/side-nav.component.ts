import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';

@Component({
  selector: 'lib-side-nav',
  imports: [CommonModule],
  templateUrl: './side-nav.component.html',
  styleUrl: './side-nav.component.scss',
})
export class SideNavComponent {
  readonly sideNavMenuItems: SideNavMenuItem[] = [
    { label: 'Dashboard', icon: 'dashboard', route: '/dashboard' },
    { label: 'Todo List', icon: 'list', route: '/todolist' },
    { label: 'Calendar', icon: 'calendar_today', route: '/calendar' },
    { label: 'Cookbook', icon: 'book', route: '/cookbook' },
    { label: 'Habits', icon: 'check_circle', route: '/habits' },
    { label: 'Household', icon: 'home', route: '/household' },
    { label: 'Inventory', icon: 'inventory', route: '/inventory' },
  ];
}

interface SideNavMenuItem {
  label: string;
  icon: string;
  route: string;
}
