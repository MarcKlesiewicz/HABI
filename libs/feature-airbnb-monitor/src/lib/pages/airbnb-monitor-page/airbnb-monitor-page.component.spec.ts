import { ComponentFixture, TestBed } from '@angular/core/testing';
import { AirbnbMonitorPageComponent } from './airbnb-monitor-page.component';

describe('AirbnbMonitorPageComponent', () => {
  let component: AirbnbMonitorPageComponent;
  let fixture: ComponentFixture<AirbnbMonitorPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AirbnbMonitorPageComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(AirbnbMonitorPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
