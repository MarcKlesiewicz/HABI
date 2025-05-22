import { Route } from '@angular/router';
import { LayoutComponent } from '@habi/lib-layout';

export const appRoutes: Route[] = [
  {
    path: '',
    redirectTo: 'dashboard',
    pathMatch: 'full',
  },
  {
    path: 'dashboard',
    component: LayoutComponent,
    loadChildren: () =>
      import('@habi/feature-dashboard').then((m) => m.DASHBOARD_ROUTES),
  },
];
