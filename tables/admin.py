from django.contrib import admin
from django.utils.html import format_html
from .models import Table, TableGroup

@admin.register(Table)
class TableAdmin(admin.ModelAdmin):
    list_display = ['number', 'seats', 'status', 'qr_code_preview', 'created_at']
    list_filter = ['status', 'seats']
    search_fields = ['number']
    ordering = ['number']
    readonly_fields = ['qr_code_preview', 'created_at', 'updated_at']
    fields = ['number', 'seats', 'status', 'qr_code_preview', 'created_at', 'updated_at']

    def qr_code_preview(self, obj):
        if obj.qr_code:
            return format_html('<img src="{}" width="100" height="100" />', obj.qr_code.url)
        return "QR 코드 없음"
    qr_code_preview.short_description = 'QR 코드'

@admin.register(TableGroup)
class TableGroupAdmin(admin.ModelAdmin):
    list_display = ['name', 'created_at']
    filter_horizontal = ['tables']
