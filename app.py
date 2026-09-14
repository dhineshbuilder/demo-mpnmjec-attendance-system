import os
import gradio as gr
import uvicorn
from backend.main import app as fastapi_app

# Create a clean UI landing page for the Hugging Face Space
with gr.Blocks(title="MPNMJEC Smart Attendance API") as demo:
    gr.Markdown("# 🎓 MPNMJEC Smart Attendance System")
    gr.Markdown("🟢 **Backend API is active and running 24/7 in the cloud.**")
    gr.Markdown("🔗 **Live Web Application:** [Open Attendance Portal](https://frontend-hazel-eight-90.vercel.app)")
    gr.Markdown("📖 **API Documentation:** [Open Swagger Docs](/docs)")

# Mount Gradio UI at /ui so all FastAPI endpoints (/token, /dashboard, /users, etc.) remain at the root level
app = gr.mount_gradio_app(fastapi_app, demo, path="/ui")

if __name__ == "__main__":
    port = int(os.getenv("PORT", "7860"))
    uvicorn.run(app, host="0.0.0.0", port=port)
