import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'lib-side-nav',
  imports: [CommonModule, RouterModule],
  templateUrl: './side-nav.component.html',
  styleUrl: './side-nav.component.scss',
})
export class SideNavComponent {
  readonly sideNavMenuItems: SideNavMenuItem[] = [
    { label: 'Dashboard', icon: 'dashboard', route: '/dashboard' },
    { label: 'Todo List', icon: 'checklist_rtl', route: '/todolist' },
    { label: 'Calendar', icon: 'calendar_today', route: '/calendar' },
    { label: 'Cookbook', icon: 'auto_stories', route: '/cookbook' },
    { label: 'Habits', icon: 'auto_graph', route: '/habits' },
    { label: 'Household', icon: 'cottage', route: '/household' },
    { label: 'Inventory', icon: 'inventory_2', route: '/inventory' },
  ];
}

interface SideNavMenuItem {
  label: string;
  icon: string;
  route: string;
}
