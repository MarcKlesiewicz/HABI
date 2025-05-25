import { CommonModule } from '@angular/common';
import { Component, inject, OnInit, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HeaderComponent } from '../components/header/header.component';
import { SideNavComponent } from '../components/side-nav/side-nav.component';

@Component({
  selector: 'lib-layout',
  imports: [CommonModule, SideNavComponent, HeaderComponent],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.scss',
})
export class LayoutComponent implements OnInit {
  title = signal<string>('');
  sideNavToggle = signal<boolean>(true);

  private readonly activatedRoute: ActivatedRoute = inject(ActivatedRoute);

  ngOnInit(): void {
    let route = this.activatedRoute.snapshot.root;
    while (route.firstChild) {
      route = route.firstChild;
    }

    this.title.set(route.title ?? '');
  }
}
