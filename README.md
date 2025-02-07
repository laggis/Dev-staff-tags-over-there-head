# FiveM Developer & Staff Tags

A FiveM resource that adds floating tags above players' heads for developers and staff members, with optional god mode functionality.

## Features

- **Developer Tags**: Red-bracketed [DEVELOPER] tag with optional god mode
- **Staff Tags**: Blue-bracketed [STAFF] tag with optional god mode
- **Distance-Based Visibility**: Tags only visible within configurable range
- **Smooth Animations**: Floating animation effect for tags
- **Modern UI**: Semi-transparent background with colored borders
- **License-Based Authorization**: Secure access control using FiveM license IDs
- **Toggle Commands**: Easy-to-use commands for both modes
- **Configurable Settings**: Customizable features through config file

## Installation

1. Download the resource
2. Place it in your FiveM server's resources folder
3. Add `ensure devtag` to your `server.cfg`
4. Configure the `config.lua` file with your settings

## Configuration

Edit `config.lua` to customize the resource:

```lua
-- Add authorized developer license IDs
Config.AuthorizedLicenses = {
    "license:your_dev_license_here",
    -- Add more developer licenses
}

-- Add authorized staff license IDs
Config.StaffLicenses = {
    "license:your_staff_license_here",
    -- Add more staff licenses
}

-- Feature Settings
Config.EnableGodMode = true        -- Enable/disable god mode for developers
Config.EnableStaffGodMode = false  -- Enable/disable god mode for staff
Config.ViewDistance = 15.0         -- Maximum distance to see tags (in meters)
```

## Commands

- `/dev` - Toggle developer mode (requires authorized license)
- `/staff` - Toggle staff mode (requires authorized license)

## Features Explained

### Developer Mode
- Displays a red-bracketed [DEVELOPER] tag
- Optional god mode (invincibility)
- Cannot be active simultaneously with staff mode
- Requires authorized license ID

### Staff Mode
- Displays a blue-bracketed [STAFF] tag
- Separate god mode configuration
- Cannot be active simultaneously with developer mode
- Requires authorized license ID

### Tag Visibility
- Tags only visible within configured distance
- Smooth floating animation
- Modern UI with background and borders
- Clear visibility with drop shadows

### Security
- License-based authorization
- Server-side verification
- No client-side configuration exposure
- Automatic state cleanup on disconnect

## Getting Your License ID

To get your FiveM license ID:
1. Join your server
2. Open server console
3. Use command: `status` or check your server logs
4. Look for a line containing: `license:xxxxxxxxxxxxxxxx`

## Support

For issues, questions, or suggestions:
1. Check the configuration
2. Verify license IDs are correct
3. Check server console for errors
4. Ensure resource is started properly

## Credits

Created by Y
