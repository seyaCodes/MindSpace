#!/usr/bin/env python3
"""Generate new UML diagrams needed for the MindSpace PFE report."""

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import numpy as np
import os

DIAG_DIR = r'd:\program\mind_space\cahierDecharge\generated_diagrams'
os.makedirs(DIAG_DIR, exist_ok=True)

FIG_BG = '#FFFFFF'
C_SYS = '#2C3E7A'        # system box fill
C_SYS_BORDER = '#1A2455'
C_ACTOR = '#3D5A8A'       # actor color
C_PKG = '#E8EDF8'         # package fill
C_PKG_BORDER = '#2C3E7A'
C_COMP = '#D4E4F7'        # component fill
C_COMP_BORDER = '#1A5276'
C_EDGE = '#E8F5E9'        # external service fill
C_EDGE_BORDER = '#1B5E20'
C_FLOW = '#FFF8E1'        # activity node fill
C_FLOW_BORDER = '#F57F17'
C_ARROW = '#333333'
C_TEXT_DARK = '#1A1A2E'
C_TEXT_WHITE = '#FFFFFF'


def draw_stick_figure(ax, x, y, label, color='#2C3E7A', size=0.05):
    """Draw a UML actor stick figure."""
    # Head circle
    circle = plt.Circle((x, y + size * 2.2), size * 0.8, color=color, fill=True, zorder=5, linewidth=1.5)
    ax.add_patch(circle)
    circle2 = plt.Circle((x, y + size * 2.2), size * 0.8, color='white', fill=True, zorder=4)
    ax.add_patch(circle2)
    head = plt.Circle((x, y + size * 2.2), size * 0.8, color=color, fill=False, linewidth=1.5, zorder=6)
    ax.add_patch(head)
    # Body
    ax.plot([x, x], [y + size * 1.4, y - size * 0.5], color=color, lw=1.8, zorder=5)
    # Arms
    ax.plot([x - size * 1.1, x + size * 1.1], [y + size * 0.7, y + size * 0.7], color=color, lw=1.8, zorder=5)
    # Legs
    ax.plot([x, x - size * 1.0], [y - size * 0.5, y - size * 2.0], color=color, lw=1.8, zorder=5)
    ax.plot([x, x + size * 1.0], [y - size * 0.5, y - size * 2.0], color=color, lw=1.8, zorder=5)
    # Label
    ax.text(x, y - size * 2.7, label, ha='center', va='top', fontsize=9,
            fontweight='bold', color=C_TEXT_DARK, wrap=True,
            multialignment='center')


def draw_rounded_box(ax, x, y, w, h, label, sublabel=None,
                     fc=C_SYS, ec=C_SYS_BORDER, text_color='white',
                     fontsize=10, zorder=3, radius=0.03):
    box = FancyBboxPatch((x - w/2, y - h/2), w, h,
                         boxstyle=f"round,pad=0,rounding_size={radius}",
                         fc=fc, ec=ec, lw=1.5, zorder=zorder)
    ax.add_patch(box)
    if sublabel:
        ax.text(x, y + h*0.12, label, ha='center', va='center',
                fontsize=fontsize, fontweight='bold', color=text_color, zorder=zorder+1)
        ax.text(x, y - h*0.2, sublabel, ha='center', va='center',
                fontsize=fontsize - 2, color=text_color, style='italic', zorder=zorder+1)
    else:
        ax.text(x, y, label, ha='center', va='center',
                fontsize=fontsize, fontweight='bold', color=text_color, zorder=zorder+1)


def arrow(ax, x1, y1, x2, y2, label='', style='->', color=C_ARROW, lw=1.3):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle=style, color=color, lw=lw),
                zorder=4)
    if label:
        mx, my = (x1+x2)/2, (y1+y2)/2
        ax.text(mx + 0.015, my + 0.015, label, ha='center', va='bottom',
                fontsize=7.5, color=C_TEXT_DARK, style='italic')


# ──────────────────────────────────────────────────────────────
# FIGURE 1 — Static Context Diagram
# ──────────────────────────────────────────────────────────────
def gen_context_diagram():
    fig, ax = plt.subplots(figsize=(10, 7), facecolor=FIG_BG)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis('off')
    ax.set_facecolor(FIG_BG)

    # Title
    ax.text(0.5, 0.96, 'Mind Space – Static Context Diagram',
            ha='center', va='top', fontsize=13, fontweight='bold', color=C_TEXT_DARK)

    # System box (center)
    draw_rounded_box(ax, 0.5, 0.50, 0.28, 0.22,
                     '«system»\nMind Space',
                     sublabel=None,
                     fc=C_SYS, ec=C_SYS_BORDER, text_color='white', fontsize=11, radius=0.02)
    ax.text(0.5, 0.50, '«system»\nMind Space', ha='center', va='center',
            fontsize=11, fontweight='bold', color='white', zorder=6)

    # Actors
    draw_stick_figure(ax, 0.10, 0.70, 'Guest\nUser')
    draw_stick_figure(ax, 0.10, 0.30, 'Authenticated\nUser')
    draw_stick_figure(ax, 0.90, 0.70, 'Sage AI\n(Backend)')
    draw_stick_figure(ax, 0.90, 0.30, 'External\nAPIs')

    # Communication lines
    ax.plot([0.155, 0.36], [0.71, 0.57], color=C_ARROW, lw=1.4, zorder=4)
    ax.plot([0.155, 0.36], [0.31, 0.44], color=C_ARROW, lw=1.4, zorder=4)
    ax.plot([0.845, 0.64], [0.71, 0.57], color=C_ARROW, lw=1.4, zorder=4)
    ax.plot([0.845, 0.64], [0.31, 0.44], color=C_ARROW, lw=1.4, zorder=4)

    # Labels on lines
    ax.text(0.26, 0.66, 'Onboarding,\nAuthentication', ha='center', fontsize=7.5,
            color=C_TEXT_DARK, style='italic', bbox=dict(fc='white', ec='none', pad=1))
    ax.text(0.26, 0.35, 'Chat, History,\nSettings', ha='center', fontsize=7.5,
            color=C_TEXT_DARK, style='italic', bbox=dict(fc='white', ec='none', pad=1))
    ax.text(0.74, 0.66, 'LLM inference,\nSafety check', ha='center', fontsize=7.5,
            color=C_TEXT_DARK, style='italic', bbox=dict(fc='white', ec='none', pad=1))
    ax.text(0.74, 0.35, 'Groq / OpenAI\n/ OpenRouter', ha='center', fontsize=7.5,
            color=C_TEXT_DARK, style='italic', bbox=dict(fc='white', ec='none', pad=1))

    # System boundary note
    ax.text(0.5, 0.03, '* «system» boundary encloses Flutter frontend, Supabase Edge Functions, and PostgreSQL+pgvector database',
            ha='center', va='bottom', fontsize=7, color='#555555', style='italic')

    plt.tight_layout(pad=0.3)
    plt.savefig(os.path.join(DIAG_DIR, 'fig_context_diagram.png'), dpi=150, bbox_inches='tight', facecolor=FIG_BG)
    plt.close()
    print('Generated: Context Diagram')


# ──────────────────────────────────────────────────────────────
# FIGURE 2 — Package Diagram
# ──────────────────────────────────────────────────────────────
def gen_package_diagram():
    fig, ax = plt.subplots(figsize=(12, 8), facecolor=FIG_BG)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis('off')
    ax.set_facecolor(FIG_BG)

    ax.text(0.5, 0.97, 'Mind Space – Package Diagram',
            ha='center', va='top', fontsize=13, fontweight='bold', color=C_TEXT_DARK)

    def pkg(x, y, w, h, title, items, color_fill, color_border):
        # Tab
        tab = FancyBboxPatch((x, y + h - 0.025), 0.18, 0.03,
                              boxstyle="square,pad=0", fc=color_border, ec='none', zorder=3)
        ax.add_patch(tab)
        ax.text(x + 0.09, y + h - 0.01, title, ha='center', va='center',
                fontsize=9, fontweight='bold', color='white', zorder=4)
        # Body
        body = FancyBboxPatch((x, y), w, h,
                               boxstyle="square,pad=0", fc=color_fill, ec=color_border, lw=1.8, zorder=2)
        ax.add_patch(body)
        # Items
        for i, item in enumerate(items):
            ix = x + w / 2
            iy = y + h - 0.07 - i * 0.078
            ell = mpatches.Ellipse((ix, iy), 0.22, 0.055, fc='white', ec=color_border, lw=1.2, zorder=4)
            ax.add_patch(ell)
            ax.text(ix, iy, item, ha='center', va='center', fontsize=7.5,
                    color=C_TEXT_DARK, fontweight='bold', zorder=5)

    # Guest package
    pkg(0.02, 0.10, 0.29, 0.78,
        '<<Guest User>>',
        ['View Onboarding', 'Sign In with Google', 'Sign In via Magic Link'],
        '#EEF2FB', C_PKG_BORDER)

    # Authenticated User package
    pkg(0.35, 0.10, 0.31, 0.78,
        '<<Authenticated User>>',
        ['Start Conversation', 'Send Message', 'Receive Streaming Reply',
         'Wrap Up Session', 'Browse Timeline', 'Browse Arcs',
         'View Arc Detail', 'Generate Arc Insight', 'Manage Settings'],
        '#EEF2FB', C_PKG_BORDER)

    # Sage AI package
    pkg(0.70, 0.10, 0.29, 0.78,
        '<<Sage AI (Backend)>>',
        ['Classify Safety', 'Stream LLM Reply', 'Generate Reflection',
         'Embed Reflection', 'Assign to Arc', 'Generate Arc Insight'],
        '#EEF2FB', '#1A5276')

    # Dependency arrows between packages
    ax.annotate('', xy=(0.35, 0.55), xytext=(0.31, 0.55),
                arrowprops=dict(arrowstyle='->', color=C_SYS_BORDER, lw=1.3,
                                linestyle='dashed'), zorder=6)
    ax.text(0.33, 0.58, '«use»', ha='center', fontsize=7.5, color=C_SYS_BORDER, style='italic')

    ax.annotate('', xy=(0.70, 0.55), xytext=(0.66, 0.55),
                arrowprops=dict(arrowstyle='->', color='#1A5276', lw=1.3,
                                linestyle='dashed'), zorder=6)
    ax.text(0.68, 0.58, '«use»', ha='center', fontsize=7.5, color='#1A5276', style='italic')

    plt.tight_layout(pad=0.3)
    plt.savefig(os.path.join(DIAG_DIR, 'fig_package_diagram.png'), dpi=150, bbox_inches='tight', facecolor=FIG_BG)
    plt.close()
    print('Generated: Package Diagram')


# ──────────────────────────────────────────────────────────────
# FIGURE 3 — Component Diagram
# ──────────────────────────────────────────────────────────────
def gen_component_diagram():
    fig, ax = plt.subplots(figsize=(13, 9), facecolor=FIG_BG)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis('off')
    ax.set_facecolor(FIG_BG)

    ax.text(0.5, 0.97, 'Mind Space – Component Diagram',
            ha='center', va='top', fontsize=13, fontweight='bold', color=C_TEXT_DARK)

    def comp(ax, x, y, w, h, title, items=None, fc=C_COMP, ec=C_COMP_BORDER, fs=8.5):
        box = FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0,rounding_size=0.012",
                              fc=fc, ec=ec, lw=1.5, zorder=3)
        ax.add_patch(box)
        # Component icon top-right
        ix, iy = x + w - 0.025, y + h - 0.025
        ax.add_patch(plt.Rectangle((ix - 0.022, iy - 0.02), 0.022, 0.018,
                                    fc='white', ec=ec, lw=1, zorder=4))
        ax.add_patch(plt.Rectangle((ix - 0.028, iy - 0.007), 0.012, 0.006,
                                    fc='white', ec=ec, lw=0.8, zorder=5))
        ax.add_patch(plt.Rectangle((ix - 0.028, iy - 0.017), 0.012, 0.006,
                                    fc='white', ec=ec, lw=0.8, zorder=5))
        # Title
        ty = y + h - 0.025 if items else y + h / 2
        ax.text(x + w / 2 - 0.015, ty, title, ha='center', va='center',
                fontsize=fs, fontweight='bold', color=C_TEXT_DARK, zorder=4)
        if items:
            for i, item in enumerate(items):
                ax.text(x + 0.015, y + h - 0.055 - i * 0.038, f'• {item}',
                        ha='left', va='top', fontsize=7, color='#333333', zorder=4)

    def boundary(ax, x, y, w, h, label, color='#888888'):
        rect = plt.Rectangle((x, y), w, h, fc='none', ec=color,
                               lw=1.2, linestyle='--', zorder=1)
        ax.add_patch(rect)
        ax.text(x + 0.01, y + h - 0.012, label, ha='left', va='top',
                fontsize=8, color=color, fontweight='bold')

    # Boundaries
    boundary(ax, 0.01, 0.05, 0.34, 0.86, '«node» Android Device', '#2C3E7A')
    boundary(ax, 0.38, 0.05, 0.37, 0.86, '«node» Supabase Cloud', '#1A5276')
    boundary(ax, 0.78, 0.05, 0.21, 0.86, '«node» External AI Services', '#1B5E20')

    # Flutter App components (left node)
    comp(ax, 0.03, 0.62, 0.30, 0.22, '«component»\nFlutter UI Layer',
         ['Home Screen', 'Chat Screen', 'History / Arcs', 'Arc Detail', 'Settings'],
         fc='#D6E4F7', ec='#2C3E7A')
    comp(ax, 0.03, 0.38, 0.30, 0.20, '«component»\nRiverpod State Layer',
         ['authProvider', 'chatProvider', 'arcsProvider', 'reflectionProvider'],
         fc='#D6E4F7', ec='#2C3E7A')
    comp(ax, 0.03, 0.10, 0.30, 0.22, '«component»\nSupabase Flutter Client',
         ['Auth (Google / Magic link)', 'HTTP / SSE streaming', 'DB realtime'],
         fc='#D6E4F7', ec='#2C3E7A')

    # Supabase components (middle node)
    comp(ax, 0.40, 0.72, 0.33, 0.14, '«component»\nAuth Service',
         ['Google OAuth 2.0', 'Email magic link', 'JWT session'],
         fc='#C8E6C9', ec='#1A5276', fs=8)
    comp(ax, 0.40, 0.50, 0.33, 0.19, '«component»\nEdge Functions (Deno)',
         ['chat-stream', 'safety-check', 'end-chat', 'assign-arc', 'generate-arc-insight'],
         fc='#C8E6C9', ec='#1A5276', fs=8)
    comp(ax, 0.40, 0.10, 0.33, 0.36, '«component»\nPostgreSQL + pgvector',
         ['profiles', 'chats', 'messages', 'reflections',
          'arcs (centroid: vector(1536))', 'arc_insights', 'emotion_spirits'],
         fc='#C8E6C9', ec='#1A5276', fs=8)

    # External AI Services (right node)
    comp(ax, 0.80, 0.68, 0.17, 0.17, '«component»\nGroq API',
         ['llama-3.3-70b', 'llama-3.1-8b'],
         fc='#C8F5C8', ec='#1B5E20', fs=7.5)
    comp(ax, 0.80, 0.47, 0.17, 0.17, '«component»\nOpenAI API',
         ['text-embedding-\n3-small'],
         fc='#C8F5C8', ec='#1B5E20', fs=7.5)
    comp(ax, 0.80, 0.10, 0.17, 0.33, '«component»\nOpenRouter API',
         ['deepseek/\ndeepseek-r1:free'],
         fc='#C8F5C8', ec='#1B5E20', fs=7.5)

    # Arrows (Flutter → Supabase)
    ax.annotate('', xy=(0.38, 0.79), xytext=(0.33, 0.79),
                arrowprops=dict(arrowstyle='->', color='#2C3E7A', lw=1.2), zorder=6)
    ax.annotate('', xy=(0.38, 0.595), xytext=(0.33, 0.55),
                arrowprops=dict(arrowstyle='->', color='#2C3E7A', lw=1.2), zorder=6)
    ax.annotate('', xy=(0.38, 0.23), xytext=(0.33, 0.23),
                arrowprops=dict(arrowstyle='->', color='#2C3E7A', lw=1.2), zorder=6)

    # Arrows (Edge Functions → External AIs)
    ax.annotate('', xy=(0.78, 0.76), xytext=(0.73, 0.63),
                arrowprops=dict(arrowstyle='->', color='#1A5276', lw=1.2), zorder=6)
    ax.annotate('', xy=(0.78, 0.55), xytext=(0.73, 0.58),
                arrowprops=dict(arrowstyle='->', color='#1A5276', lw=1.2), zorder=6)
    ax.annotate('', xy=(0.78, 0.26), xytext=(0.73, 0.53),
                arrowprops=dict(arrowstyle='->', color='#1A5276', lw=1.2), zorder=6)

    # Protocol labels
    ax.text(0.355, 0.82, 'HTTPS', fontsize=7, color='#333333', style='italic')
    ax.text(0.355, 0.57, 'SSE / REST', fontsize=7, color='#333333', style='italic')
    ax.text(0.355, 0.26, 'PostgREST', fontsize=7, color='#333333', style='italic')

    plt.tight_layout(pad=0.3)
    plt.savefig(os.path.join(DIAG_DIR, 'fig_component_diagram.png'), dpi=150, bbox_inches='tight', facecolor=FIG_BG)
    plt.close()
    print('Generated: Component Diagram')


# ──────────────────────────────────────────────────────────────
# FIGURE 4 — Activity Diagram: Arc Assignment Algorithm
# ──────────────────────────────────────────────────────────────
def gen_activity_diagram():
    fig, ax = plt.subplots(figsize=(9, 14), facecolor=FIG_BG)
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis('off')
    ax.set_facecolor(FIG_BG)

    ax.text(0.5, 0.985, 'Mind Space – Activity Diagram: Arc Assignment Algorithm',
            ha='center', va='top', fontsize=11, fontweight='bold', color=C_TEXT_DARK)

    def action(ax, x, y, w, h, text, fc=C_FLOW, ec=C_FLOW_BORDER):
        box = FancyBboxPatch((x - w/2, y - h/2), w, h,
                              boxstyle="round,pad=0,rounding_size=0.025",
                              fc=fc, ec=ec, lw=1.5, zorder=3)
        ax.add_patch(box)
        ax.text(x, y, text, ha='center', va='center', fontsize=8.5,
                color=C_TEXT_DARK, fontweight='bold', zorder=4, multialignment='center')

    def decision(ax, x, y, size, text):
        diamond = plt.Polygon([[x, y + size], [x + size*1.7, y],
                                [x, y - size], [x - size*1.7, y]],
                               fc='#FFF9C4', ec='#F9A825', lw=1.5, zorder=3)
        ax.add_patch(diamond)
        ax.text(x, y, text, ha='center', va='center', fontsize=8,
                color=C_TEXT_DARK, fontweight='bold', zorder=4, multialignment='center')

    def start_end(ax, x, y, r, kind='start'):
        c = plt.Circle((x, y), r, fc='#1A1A2E' if kind == 'start' else 'none',
                         ec='#1A1A2E', lw=2, zorder=4)
        ax.add_patch(c)
        if kind == 'end':
            c2 = plt.Circle((x, y), r * 0.6, fc='#1A1A2E', ec='none', zorder=5)
            ax.add_patch(c2)

    def v_arrow(ax, x, y1, y2, label='', side='right'):
        ax.annotate('', xy=(x, y2), xytext=(x, y1),
                    arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)
        if label:
            lx = x + 0.04 if side == 'right' else x - 0.04
            ha = 'left' if side == 'right' else 'right'
            ax.text(lx, (y1 + y2) / 2, label, ha=ha, va='center',
                    fontsize=8, color='#555555', style='italic')

    def h_arrow(ax, x1, x2, y, label='', va_pos='top'):
        ax.annotate('', xy=(x2, y), xytext=(x1, y),
                    arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)
        if label:
            ax.text((x1 + x2) / 2, y + (0.012 if va_pos == 'top' else -0.012),
                    label, ha='center', va='bottom' if va_pos == 'top' else 'top',
                    fontsize=8, color='#555555', style='italic')

    # Layout (y from top=0.96 down)
    y_start  = 0.945
    y_a1     = 0.875   # Wrap Up tapped
    y_a2     = 0.800   # Generate reflection JSON
    y_a3     = 0.725   # Compute text embedding
    y_d1     = 0.650   # User has existing arcs?
    y_a4     = 0.570   # Compute cosine similarity
    y_d2     = 0.490   # similarity >= 0.78?
    y_d3     = 0.390   # similarity >= 0.65?
    y_a5r    = 0.295   # Assign to closest arc (right branch)
    y_a5l    = 0.295   # Create new arc (left — from d1)
    y_a6r    = 0.220   # Update centroid (right branch)
    y_a6l    = 0.220   # Name arc via LLM (create branch)
    y_merge  = 0.135   # merge
    y_end    = 0.065

    CX = 0.50   # center x
    LX = 0.20   # left branch x (new arc)
    RX = 0.78   # right branch x (soft zone → assign)

    start_end(ax, CX, y_start, 0.018, 'start')
    v_arrow(ax, CX, y_start - 0.018, y_a1 + 0.03)
    action(ax, CX, y_a1, 0.40, 0.05, 'User taps «Wrap Up» button')
    v_arrow(ax, CX, y_a1 - 0.025, y_a2 + 0.025)
    action(ax, CX, y_a2, 0.44, 0.045, 'Generate reflection JSON\n(spirit, what_sage_heard, question, perspective)')
    v_arrow(ax, CX, y_a2 - 0.022, y_a3 + 0.022)
    action(ax, CX, y_a3, 0.42, 0.040, 'Compute text embedding\n(OpenAI text-embedding-3-small, 1536 dims)')
    v_arrow(ax, CX, y_a3 - 0.020, y_d1 + 0.040)
    decision(ax, CX, y_d1, 0.038, 'User has\nexisting arcs?')

    # NO branch (left) → create new arc immediately
    ax.annotate('', xy=(LX, y_d1), xytext=(CX - 0.064, y_d1),
                arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)
    ax.text((CX - 0.064 + LX) / 2, y_d1 + 0.015, 'No', ha='center', fontsize=8, color='#555555', style='italic')
    v_arrow(ax, LX, y_d1, y_a5l + 0.022)
    action(ax, LX, y_a5l, 0.30, 0.040, 'Create new Arc\n(name via LLM, 2–4 words)')
    v_arrow(ax, LX, y_a5l - 0.020, y_a6l + 0.022)
    action(ax, LX, y_a6l, 0.28, 0.038, 'Set centroid = embedding\nAssign reflection to Arc')

    # YES branch (center) → compute similarity
    v_arrow(ax, CX, y_d1 - 0.038, y_a4 + 0.020, 'Yes')
    action(ax, CX, y_a4, 0.44, 0.038, 'Compute cosine similarity\nvs. all arc centroids (pgvector <=>)')
    v_arrow(ax, CX, y_a4 - 0.019, y_d2 + 0.040)
    decision(ax, CX, y_d2, 0.038, 'similarity\n≥ 0.78?')

    # >= 0.78 branch (right) → assign
    ax.annotate('', xy=(RX, y_d2), xytext=(CX + 0.064, y_d2),
                arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)
    ax.text((CX + 0.064 + RX) / 2, y_d2 + 0.015, 'Yes', ha='center', fontsize=8, color='#555555', style='italic')
    v_arrow(ax, RX, y_d2, y_a5r + 0.022)
    action(ax, RX, y_a5r, 0.30, 0.040, 'Assign reflection\nto matching Arc')
    v_arrow(ax, RX, y_a5r - 0.020, y_a6r + 0.022)
    action(ax, RX, y_a6r, 0.28, 0.038, 'Update centroid\n(incremental avg)')

    # < 0.78 branch → check 0.65
    v_arrow(ax, CX, y_d2 - 0.038, y_d3 + 0.040, 'No')
    decision(ax, CX, y_d3, 0.038, 'similarity\n≥ 0.65?')

    # >= 0.65 (soft zone) → assign with flag
    ax.annotate('', xy=(RX, y_d3), xytext=(CX + 0.064, y_d3),
                arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)
    ax.text((CX + 0.064 + RX) / 2, y_d3 + 0.015, 'Yes', ha='center', fontsize=8, color='#555555', style='italic')
    # connect to same a5r box
    ax.plot([RX, RX], [y_d3, y_a5r + 0.022], color=C_ARROW, lw=1.3, zorder=4)
    ax.text(RX + 0.015, (y_d3 + y_a5r) / 2, '(needs_review=true)', fontsize=7, color='#666666', style='italic')

    # < 0.65 → create new arc (left branch from d3)
    ax.annotate('', xy=(LX, y_d3), xytext=(CX - 0.064, y_d3),
                arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)
    ax.text((CX - 0.064 + LX) / 2, y_d3 + 0.015, 'No', ha='center', fontsize=8, color='#555555', style='italic')
    ax.plot([LX, LX], [y_d3, y_a5l + 0.022], color=C_ARROW, lw=1.3, zorder=4)

    # Merge all branches at bottom
    ax.plot([LX, LX], [y_a6l - 0.019, y_merge], color=C_ARROW, lw=1.3, zorder=4)
    ax.plot([RX, RX], [y_a6r - 0.019, y_merge], color=C_ARROW, lw=1.3, zorder=4)
    ax.plot([LX, RX], [y_merge, y_merge], color=C_ARROW, lw=1.3, zorder=4)
    # Center merge point
    ax.annotate('', xy=(CX, y_merge - 0.001), xytext=(CX, y_merge),
                arrowprops=dict(arrowstyle='->', color=C_ARROW, lw=1.3), zorder=4)

    action(ax, CX, y_merge - 0.032, 0.40, 0.038, 'Show Reflection Card to user\n(spirit, what_sage_heard, question)')

    v_arrow(ax, CX, y_merge - 0.051, y_end + 0.018)
    start_end(ax, CX, y_end, 0.018, 'end')

    plt.tight_layout(pad=0.3)
    plt.savefig(os.path.join(DIAG_DIR, 'fig_activity_diagram.png'), dpi=150, bbox_inches='tight', facecolor=FIG_BG)
    plt.close()
    print('Generated: Activity Diagram')


if __name__ == '__main__':
    gen_context_diagram()
    gen_package_diagram()
    gen_component_diagram()
    gen_activity_diagram()
    print('\nAll diagrams generated in:', DIAG_DIR)
