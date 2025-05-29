import { ComponentFixture, TestBed } from '@angular/core/testing';
import { AirbnbStatsComponent } from './airbnb-stats.component';

describe('AirbnbStatsComponent', () => {
  let component: AirbnbStatsComponent;
  let fixture: ComponentFixture<AirbnbStatsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AirbnbStatsComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(AirbnbStatsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
