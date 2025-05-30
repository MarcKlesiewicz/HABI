import { ComponentFixture, TestBed } from '@angular/core/testing';
import { AirbnbChecklistComponent } from './airbnb-checklist.component';

describe('AirbnbChecklistComponent', () => {
  let component: AirbnbChecklistComponent;
  let fixture: ComponentFixture<AirbnbChecklistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AirbnbChecklistComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(AirbnbChecklistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
