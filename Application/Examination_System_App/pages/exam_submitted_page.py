import flet as ft
import asyncio

class ExamSubmittedPage(ft.View):
    def __init__(self, page: ft.Page):
        super().__init__(route="/exam_submitted")
        self.page = page
        self.remaining_seconds = 60  # countdown in seconds

        # Success message and countdown
        self.message = ft.Text("✅ Exam submitted successfully!", theme_style="headlineMedium", color="green")
        self.countdown_text = ft.Text(f"Redirecting in {self.remaining_seconds} seconds...")

        self.back_btn = ft.ElevatedButton(
            "Back to Available Exams",
            on_click=self.back_to_dashboard,
            bgcolor="blue",
            color="white"
        )

        self.controls = [
            ft.Container(
                content=ft.Column(
                    [
                        self.message,
                        self.countdown_text,
                        self.back_btn
                    ],
                    alignment=ft.MainAxisAlignment.CENTER,
                    horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                    tight=True
                ),
                alignment=ft.alignment.center,
                expand=True,
            )
        ]

        # Start live countdown
        self.page.run_task(self.countdown)

    async def countdown(self):
        while self.remaining_seconds > 0:
            self.countdown_text.value = f"Redirecting in {self.remaining_seconds} seconds..."
            self.page.update()
            await asyncio.sleep(1)
            self.remaining_seconds -= 1

        # Time's up → redirect
        self.back_to_dashboard(None)

    def back_to_dashboard(self, _):
        self.page.go("/student")
