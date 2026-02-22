for i in "odm" "vendor"; do
    PROP="$i/etc/build.prop"
    if [[ "$i" == "vendor" ]]; then
        PROP="$i/build.prop"
    fi

    {
        echo "# Added by target/p3s/patches/variants/customize.sh"
        echo "import /$i/etc/sku/\${ro.boot.em.model}.prop"
    } >> "$WORK_DIR/$PROP"

    unset PROP
done

if ! grep -q "init_30_0 tee_file" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    {
        echo "(allow init_30_0 tee_file (dir (mounton)))"
        echo "(allow priv_app_30_0 tee_file (dir (getattr)))"
        echo "(allow init_30_0 vendor_fw_file (file (mounton)))"
        echo "(allow priv_app_30_0 vendor_fw_file (file (getattr)))"
        echo "(allow init_30_0 vendor_npu_firmware_file (file (mounton)))"
        echo "(allow priv_app_30_0 vendor_npu_firmware_file (file (getattr)))"
    } >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi
