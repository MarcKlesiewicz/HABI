import { Routes } from '@angular/router';
import { HabitTrackerPageComponent } from './lib/pages/habit-tracker-page/habit-tracker-page.component';

export const HABIT_TRACKER_ROUTES: Routes = [
  {
    path: '',
    title: 'Habit Tracker',
    component: HabitTrackerPageComponent,
  },
];
