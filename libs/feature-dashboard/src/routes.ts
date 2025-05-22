import { Routes } from '@angular/router';
import { DashboardPageComponent } from './lib/pages/dashboard-page/dashboard-page.component';

export const DASHBOARD_ROUTES: Routes = [
  {
    path: '',
    component: DashboardPageComponent,
  },
];
