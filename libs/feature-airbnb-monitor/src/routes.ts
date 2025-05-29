import { Routes } from '@angular/router';
import { AirbnbMonitorPageComponent } from './lib/pages/airbnb-monitor-page/airbnb-monitor-page.component';

export const AIRBNB_MONITOR_ROUTES: Routes = [
  {
    path: '',
    title: 'Airbnb Monitor',
    component: AirbnbMonitorPageComponent,
  },
];
