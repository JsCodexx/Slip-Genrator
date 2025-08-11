# SlipGen - Professional Slip Generation Platform

A comprehensive, modern web application for generating professional slips with customizable templates, built with Next.js, TypeScript, Tailwind CSS, and Supabase.

## 🚀 Features

### Core Functionality
- **Multi-format Slip Generation**: Support for 20+ pre-built slip templates
- **Product Categories**: 4 categories (Fruits, Vegetables, Shakes/Juices, Mixed) with proper units
- **Dynamic Content**: Real-time slip generation with customizable items and quantities
- **Professional Output**: Clean, print-ready slip formats with correct units
- **User Management**: Secure authentication with multiple providers

### User Dashboard
- **Slip Creation**: Intuitive interface for building slips
- **Template Selection**: Browse and preview available formats
- **Slip Management**: View, archive, and delete generated slips
- **Print Integration**: Direct printing and PDF generation

### Admin Features
- **Template Management**: Create, edit, and manage slip formats
- **System Statistics**: Monitor users, slips, and revenue
- **User Administration**: Manage user accounts and permissions
- **Content Control**: Activate/deactivate slip templates

### Technical Features
- **Responsive Design**: Mobile-first, modern UI/UX
- **Dark Mode**: Built-in theme switching
- **Real-time Updates**: Live data synchronization
- **Type Safety**: Full TypeScript implementation
- **Console Logging**: All logs prefixed with 'collab' for easy debugging

## 🛠️ Tech Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS, CSS Modules
- **Backend**: Supabase (PostgreSQL, Auth, Real-time)
- **Authentication**: Supabase Auth with multiple providers
- **Database**: PostgreSQL with optimized schema
- **Deployment**: Vercel-ready configuration

## 📁 Project Structure

```
slip/
├── app/                    # Next.js app directory
│   ├── auth/              # Authentication pages
│   ├── slips/             # User slips management
│   ├── templates/         # Template browsing
│   ├── admin/             # Admin dashboard
│   ├── globals.css        # Global styles
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Main dashboard
├── components/             # Reusable components
│   ├── AuthForm.tsx       # Authentication form
│   └── Navigation.tsx     # Navigation component
├── lib/                    # Utility libraries
│   └── supabase.ts        # Supabase client
├── database-setup.sql      # Database schema
├── env.example            # Environment variables template
└── README.md              # This file
```

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd slip
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp env.example .env.local
   ```
   
   Fill in your Supabase credentials:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Set up the database**
   - Run the SQL commands from `database-setup.sql` in your Supabase SQL editor
   - This creates all necessary tables and sample data

5. **Start the development server**
   ```bash
   npm run dev
   ```

6. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## 🗄️ Database Schema

### Core Tables
- **users**: User account information
- **slip_formats**: Available slip templates
- **slips**: Generated slip records
- **slip_items**: Individual items within slips
- **fruits**: Product catalog

### Key Relationships
- Users can generate multiple slips
- Each slip uses one format template
- Slips contain multiple items
- Items reference products from the catalog

## 🔐 Authentication

The platform supports multiple authentication methods:
- Email/Password
- Google OAuth
- GitHub OAuth
- Magic Link authentication

All authentication is handled securely through Supabase Auth.

## 🎨 Customization

### Adding New Slip Formats
1. Navigate to Admin Dashboard
2. Click "Create New Format"
3. Provide name, description, and HTML template
4. Set active status
5. Save and test

### Modifying Templates
- Edit existing formats through the admin interface
- HTML templates support standard markup and CSS
- Real-time preview available during editing

## 📱 Responsive Design

The application is built with a mobile-first approach:
- Responsive grid layouts
- Touch-friendly interfaces
- Optimized for all screen sizes
- Progressive Web App features

## 🚀 Deployment

### Vercel (Recommended)
1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Other Platforms
- Netlify
- Railway
- DigitalOcean App Platform
- Any Node.js hosting service

## 🔧 Development

### Available Scripts
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm run lint         # Run ESLint
npm run type-check   # Run TypeScript checks
```

### Code Style
- TypeScript strict mode enabled
- ESLint configuration included
- Prettier formatting
- Consistent component structure

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Verify Supabase credentials in `.env.local`
   - Check if database schema is properly set up

2. **Authentication Issues**
   - Ensure Supabase Auth is enabled
   - Check redirect URLs in Supabase settings

3. **Build Errors**
   - Clear `.next` folder and reinstall dependencies
   - Verify TypeScript types are correct

### Debug Mode
All console logs are prefixed with 'collab' for easy identification:
```javascript
console.log('collab: User logged in successfully')
console.error('collab: Database connection failed')
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the GitHub repository
- Check the documentation
- Review the troubleshooting section

## 🎯 Roadmap

### Upcoming Features
- [ ] Advanced template editor with drag-and-drop
- [ ] Bulk slip generation
- [ ] API endpoints for external integrations
- [ ] Advanced analytics and reporting
- [ ] Multi-language support
- [ ] Mobile app (React Native)

### Version History
- **v1.0.0**: Initial release with core functionality
- **v1.1.0**: Admin dashboard and template management
- **v1.2.0**: Enhanced UI and mobile optimization

---

Built with ❤️ using Next.js and Supabase
