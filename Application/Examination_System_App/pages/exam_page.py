import asyncio
import flet as ft

class ExamPage(ft.View):
    """Exam Page"""

    def __init__(self, page: ft.Page):
        super().__init__(route="/exam")
        self.page = page
        self.exam_submitted = False  # 🔒 Prevent update after navigation

        self.remaining_seconds = 60 * 60  # ⏱ 1 hour
        self.timer_text = ft.Text("Time Left: 60:00", size=20, weight="bold", color="red")

        # Sample mock questions
        self.questions = [
            {
                "id": 1,
                "text": "What is the capital of France?",
                "options": ["Paris", "London", "Rome", "Berlin"]
            },
            {
                "id": 2,
                "text": "2 + 2 = ?",
                "options": ["3", "4", "5", "2"]
            },
            {
                "id": 2,
                "text": "2 + 2 = ?",
                "options": ["3", "4", "5", "2"]
            }
        ]

        self.selected_answers = {}

        # Build question UI
        question_controls = []
        for q in self.questions:
            options = [
                ft.Radio(value=opt, label=opt)
                for opt in q["options"]
            ]
            question_controls.append(
                ft.Column([
                    ft.Text(f"Q{q['id']}: {q['text']}", size=16, weight="bold"),
                    ft.RadioGroup(
                        content=ft.Column(options),
                        on_change=self.on_answer_change(q["id"])
                    ),
                    ft.Divider()
                ])
            )

        # Layout
        self.controls = [
            ft.Column([
                ft.Row(
                    [
                        ft.Text("📝 Exam Page", theme_style="headlineMedium"),
                        ft.Container(content=self.timer_text, expand=True, alignment=ft.alignment.center_right)
                    ]
                ),
                ft.Divider(),
                ft.Column(question_controls, spacing=20, scroll=ft.ScrollMode.AUTO),
                ft.ElevatedButton("Submit Exam", on_click=self.submit_exam, bgcolor="blue", color="white", height=50),
            ], spacing=25, expand=True, scroll=ft.ScrollMode.AUTO)
        ]

        # Start countdown
        self.page.run_task(self.countdown)

    def on_answer_change(self, question_id):
        def handler(e):
            self.selected_answers[question_id] = e.control.value
        return handler

    async def countdown(self):
        while self.remaining_seconds > 0:
            if self.exam_submitted or not self.page:
                return  # Exit if submitted or page is gone

            mins, secs = divmod(self.remaining_seconds, 60)
            self.timer_text.value = f"Time Left: {mins:02d}:{secs:02d}"
            self.page.update()
            await asyncio.sleep(1)
            self.remaining_seconds -= 1

        # Time’s up and not submitted
        if not self.exam_submitted and self.page:
            self.timer_text.value = "⏰ Time's up!"
            self.page.update()
            await asyncio.sleep(2)
            self.page.go("/student")

    def submit_exam(self, _):
        self.exam_submitted = True  # 🔒 Cancel countdown
        print("Submitted Answers:", self.selected_answers)
        self.page.go("/exam_submitted")
