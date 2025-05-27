import { ComponentFixture, TestBed } from '@angular/core/testing';
import { HabitTrackerPageComponent } from './habit-tracker-page.component';

describe('HabitTrackerPageComponent', () => {
  let component: HabitTrackerPageComponent;
  let fixture: ComponentFixture<HabitTrackerPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HabitTrackerPageComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(HabitTrackerPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
