import { Routes } from '@angular/router';
import { DashboardPageComponent } from './lib/pages/dashboard-page/dashboard-page.component';

export const DASHBOARD_ROUTES: Routes = [
  {
    path: '',
    title: 'Dashboard',
    component: DashboardPageComponent,
  },
];
